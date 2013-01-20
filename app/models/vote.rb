class Vote < ActiveRecord::Base
  attr_accessible :positive, :post, :user
  has_one :user
  has_one :post
end
