class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  has_many :episodes, inverse_of: :lesson
  accepts_nested_attributes_for :episodes, allow_destroy: true
  
  validates_presence_of :name
end
