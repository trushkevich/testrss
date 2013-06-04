class Subscription < ActiveRecord::Base
  attr_accessible :channel_id, :user_id, :name

  belongs_to :user
  belongs_to :channel

  validates :channel_id, presence: true 
  validates :user_id, presence: true 
end
