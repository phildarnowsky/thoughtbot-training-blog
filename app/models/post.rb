class Post < ActiveRecord::Base
  named_scope :published, :conditions => {:published => true}
  named_scope :ordered, :order => 'created_at DESC'
  validates_presence_of :title, :body
  has_many :comments
end
