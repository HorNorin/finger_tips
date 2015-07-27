class Episode < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  
  has_many :comments
  belongs_to :lesson, counter_cache: true, inverse_of: :episodes
  
  mount_uploader :image, ImageUploader
  
  validates_presence_of :title, :youtube_url, :duration, :description
  validates_numericality_of :duration, greater_than: 0
  validates_presence_of :lesson
end
