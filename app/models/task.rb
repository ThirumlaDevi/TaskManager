class Task < ApplicationRecord
  belongs_to :user
  has_one :weather_info
  validates :title, presence: true
  validates :description, presence: true, length: { minimum: 4 }
  # add due date presance once conversion of date to utc as per location of user, to epoc is done
end
