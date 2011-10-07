class Post < ActiveRecord::Base
  belongs_to :user
  has_many :votes , :dependent => :destroy
  validates :description, :presence => true
  validates :user_id, :presence => true
end
