should "assign all Posts to @posts" do
  assert_equal Post.all, assigns(:posts)
end

should_assign_to "@posts", :equals => "Post.all"

class BandsController < ApplicationController
  def show
    @band = Band.find(params[:band_name])
  end
end

    posts GET    /posts          { :controller=>"posts", :action=>"index"   }
          POST   /posts          { :controller=>"posts", :action=>"create"  }
 new_post GET    /posts/new      { :controller=>"posts", :action=>"new"     }
edit_post GET    /posts/:id/edit { :controller=>"posts", :action=>"edit"    }
     post GET    /posts/:id      { :controller=>"posts", :action=>"show"    }
          PUT    /posts/:id      { :controller=>"posts", :action=>"update"  }
          DELETE /posts/:id      { :controller=>"posts", :action=>"destroy" }
          
posts_url,     posts_path     # index & create actions
new_post_url,  new_post_path  # new action
edit_post_url, edit_post_path # edit action
post_url,      post_path      # show, update, & destroy actions

new_post_url  # http://localhost:3000/posts/new
new_post_path # /posts/new

>> post = Post.new
=> #<Post id: nil, title: nil, body: nil, created_at: nil, updated_at: nil>

>> post.save
  Post Create (52.4ms)
  INSERT INTO "posts" ("updated_at", "title", "body", "created_at") 
  VALUES('2009-01-26 19:37:14', NULL, NULL, '2009-01-26 19:37:14')
=> true

>> Post.last
  Post Load (0.4ms)
  SELECT * FROM "posts" ORDER BY posts.id DESC LIMIT 1
=> #<Post id: 3, title: nil, body: nil, created_at: "2009-01-26 19:37:14", updated_at: "2009-01-26 19:37:14">

>> post = Post.new
=> #<Post id: nil, title: nil, body: nil, created_at: nil, updated_at: nil>
>> post.save
=> false
>> post.errors.full_messages
=> ["Body can't be blank", "Title can't be blank"]






