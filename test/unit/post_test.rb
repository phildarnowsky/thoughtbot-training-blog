require 'test_helper'

class PostTest < ActiveSupport::TestCase

  should_have_many :comments
  should_validate_presence_of :title
  should_validate_presence_of :body
end
