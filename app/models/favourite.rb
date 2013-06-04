class Favourite < ActiveRecord::Base
  attr_accessible :favourite_id, :favourite_type, :user_id

  belongs_to :user
  belongs_to :favouritable, :polymorphic => true
end
