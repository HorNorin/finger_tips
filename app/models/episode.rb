class Episode < ActiveRecord::Base
  translates :title, :description, :slug
  
  extend FriendlyId
  friendly_id :title, use: [:slugged, :globalize]
  
  has_many :comments
  belongs_to :lesson, counter_cache: true, inverse_of: :episodes
  
  mount_uploader :image, ImageUploader
  
  
  validates_presence_of :lesson
  validates_presence_of :title, :youtube_url, :duration, :description
  validates_numericality_of :duration, greater_than: 0
  
  scope :search, ->(title) do
    column_name = "episode_translations.title"
    with_translations(I18n.locale).where("#{column_name} LIKE ?", "#{title}%")
  end
end
