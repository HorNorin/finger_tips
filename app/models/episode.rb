class Episode < ActiveRecord::Base
  belongs_to :lesson
  has_many :comments
end
