class Subscription < ActiveRecord::Base
  attr_accessible :channel_id, :user_id, :name

  belongs_to :user
  belongs_to :channel

  validates :channel_id, presence: true 
  validates :user_id, presence: true 

  def self.by_user_channel_ids(user_id, channel_id)
    Subscription.where(user_id: user_id, channel_id: channel_id).first
  end

end
