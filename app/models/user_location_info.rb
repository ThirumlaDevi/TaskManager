class UserLocationInfo < ApplicationRecord
  self.table_name = 'user_location_info'
  belongs_to :user, class_name: 'User'
end
