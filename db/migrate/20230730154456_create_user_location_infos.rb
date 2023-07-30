class CreateUserLocationInfo < ActiveRecord::Migration[7.0]
  def change
    create_table :user_location_info do |t|
      t.belongs_to :user, index: { unique: true }, foreign_key: true
      t.integer :latitude
      t.integer :longitude
      t.timestamps
    end
  end
end
