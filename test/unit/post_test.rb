require 'test_helper'

class PostTest < ActiveSupport::TestCase

  should_have_many :comments
  should_validate_presence_of :title
  should_validate_presence_of :body
  
  context "published an unpublished named scope" do
    setup do
      @post_1 = Factory(:published_post)
      @post_2 = Factory(:unpublished_post)
    end
    
    should "find only published posts" do
      assert_equal [@post_1], Post.published
    end
  end
  
  context "ordered named scope" do
    setup do
      @post_1 = Factory(:post, :created_at => 10.minutes.ago)
      @post_2 = Factory(:post, :created_at => 5.minutes.ago)
    end
    
    should "find posts in reverse chronological order" do
      assert_equal [@post_2, @post_1], Post.ordered
    end
  end
end
