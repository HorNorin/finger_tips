class Episode < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_many :comments
  belongs_to :lesson, counter_cache: true
end
