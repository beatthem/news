class Post < ActiveRecord::Base
  attr_accessible :content, :title, :rating
  validates :title, :presence => true, :length => { :minimum => 5}
  validates :content, :presence => true
  belongs_to :user
  has_many :votes
end
