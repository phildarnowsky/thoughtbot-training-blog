require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  should_route :get, '/posts', :action => :index

  include PostsHelper

  context 'on GET to index on one pubbed n one not' do
    setup do
      @post1 = Factory(:published_post)
      @post2 = Factory(:unpublished_post)
      get :index
    end
    
    should "show only pubbed post" do
      assert_equal [@post1], assigns(:posts)
    end
    
  end # context
  
  context 'on GET to index on multple pubbed posts' do
      setup do
        @post1 = Factory(:post, :title => "Post 1",
                                :body => "Body 1",
                                :published => true,
                                :created_at => 10.minutes.ago)
        @post2 = Factory(:post, :title => "Post 2",
                                :body => "Body 2",
                                :published => true,
                                :created_at => 5.minutes.ago)
        @post3 = Factory(:unpublished_post)
        
        get :index
      end

    should_respond_with :success
    should_render_template :index

    should "render navigation with a link to new post" do
      assert_select 'div.navigation' do
        assert_select 'a[href=?]', posts_path, :count => 0
        assert_select 'a[href=?]', new_post_path
      end
    end

    should "show the current time in a paragraph" do
      assert_select 'p', :text => /The time is now/
    end

    # should_assign_to :posts, :equals => '[@post2, @post1]'
    should "sort the posts, most recent first, and assign to @posts" do
      reverse_sorted_posts = [@post2, @post1]
      assert_equal reverse_sorted_posts, assigns(:posts)
    end

    should "render the posts" do
      assigns(:posts).each do |post|
        assert_select 'h2>a[href=?]', post_path(post), :text => post.title
        assert_select 'p', display_author_of(post)
        assert_select 'p', post.body
      end
    end

    should "show a link to create a new post" do
      assert_select 'a[href=?]', new_post_path
    end  
  end # context 'on GET to index'

  context "on GET to show for a published post" do
    setup do
      @post = Factory(:post, :published => true)
      @comment = Factory(:comment, :post => @post)
      get :show, :id => @post
    end

    should_respond_with :success
    should_render_template :show
    should_assign_to :comment

    should "render the post" do
      assert_select 'h2>a[href=?]', post_path(@post), :text => @post.title
      assert_select 'p', @post.body
    end

    should "have a form to post a comment" do
      assert_select 'form[action=?][method=post]', post_comments_path(@post) do
        assert_select 'input[type=text][name=?]', 'comment[title]'
        assert_select 'textarea[name=?]', 'comment[body]'
        assert_select 'input[type=submit]'
      end
    end

    should "display comments" do
      assert_select 'h3', @comment.title
      assert_select 'p', @comment.body
    end
    
    should "have a button to delete a comment" do
      assert_select 'div[id=?]', "comment_#{@comment.id}" do
        assert_select 'form[action=?]', post_comment_path(@comment) do
          assert_select 'input[type=hidden][name=_method][value=delete]'
          assert_select 'input[type=submit]'
        end
      end
    end
  end

  context "on GET to show for an unpublished post" do
    setup do
      @post = Factory(:post, :published => false)
      get :show, :id => @post
    end

    should_respond_with :redirect
    should_redirect_to 'posts_path'
  end

  context "on GET to new" do
    setup do
      get :new
    end

    should_respond_with :success
    should_render_template :new
    should_assign_to :post

    should "render navigation with a link to index" do
      assert_select 'div.navigation' do
        assert_select 'a[href=?]', posts_path
        assert_select 'a[href=?]', new_post_path, :count => 0
      end
    end

    should "show a form to create a new post" do
      assert_select 'form[action=?][method=post]', posts_path do
        assert_select 'input[type=text][name=?]', 'post[title]'
        assert_select 'input[type=text][name=?]', 'post[author]'
        assert_select 'textarea[name=?]', 'post[body]'
        assert_select 'input[type=checkbox][name=?]', 'post[published]'
        assert_select 'input[type=submit]'
      end
    end
  end

  context "on POST to create with valid post parameters" do
    setup do
      @post_count = Post.count
      post :create, :post => { :title => 'Test Title',  :body => 'Test Body' }
    end

    should_redirect_to "posts_path"
    should_set_the_flash_to /created/

    should "create a new post record" do
      assert_equal @post_count + 1, Post.count
    end

    should "create a post with the given title" do
      assert_not_nil post = Post.last
      assert_equal   'Test Title', post.title
    end
  end

  context "on POST to create with invalid post parameters" do
    setup do
      post :create, :post => {}
    end

    should_respond_with :success
    should_render_template :new
    should_not_set_the_flash

    should "display error messages" do
      assert_select '#errorExplanation'
    end
  end

  context "on GET to edit" do
    setup do
      @post = Factory(:post)
      get :edit, :id => @post
    end

    should_respond_with :success
    should_render_template :edit
    should_assign_to :post, :equals => '@post'

    should "show a form to edit a post" do
      assert_select 'form[action=?][method=post]', post_path(@post) do
        assert_select 'input[type=text][name=?]', 'post[title]'
        assert_select 'input[type=text][name=?]', 'post[author]'
        assert_select 'textarea[name=?]', 'post[body]'
        assert_select 'input[type=checkbox][name=?]', 'post[published]'
        assert_select 'input[type=submit]'
      end
    end
  end

  context 'on PUT to update with valid parameters' do
    setup do
      @post = Factory(:post)
      @new_post_attributes = { :title => "New Title", :body => "New Body" }
      put :update, :id => @post, :post => @new_post_attributes
    end

    should_redirect_to "posts_path"
    should_set_the_flash_to /updated/

    should "update the post" do
      assert_equal "New Title", @post.reload.title
      assert_equal "New Body", @post.reload.body
    end
  end

  context 'on PUT to update with invalid parameters' do
    setup do
      @post = Factory(:post)
      put :update, :id => @post, :post => {:title => nil, :body => nil}
    end

    should_respond_with :success
    should_render_template :edit

    should "display error messages" do
      assert_select '#errorExplanation'
    end
  end
end
