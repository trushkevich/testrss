class Article < ActiveRecord::Base
  attr_accessible :channel_id, :description, :link, :published_at, :title

  belongs_to :channel
  has_many :favourites, :as => :favouritable
  has_many :users, :through => :favourites

  validates :channel_id, presence: true 
  validates :link, presence: true 
  validates :title, presence: true 

  acts_as_commentable
  
end
