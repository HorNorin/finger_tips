class Lesson < ActiveRecord::Base
  translates :name, :slug
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :globalize]
  
  has_many :episodes, inverse_of: :lesson
  accepts_nested_attributes_for :episodes, allow_destroy: true
  
  validates_presence_of :name
  
  scope :search, ->(name) do
    column_name = "lesson_translations.name"
    with_translations(I18n.locale).where("#{column_name} LIKE ?", "#{name}%")
  end
end
