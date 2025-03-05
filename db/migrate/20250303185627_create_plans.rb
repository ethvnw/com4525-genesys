class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.belongs_to :trip
      t.string :title, null: false
      t.integer :type, null: false
      t.string :start_location_name
      t.decimal :start_location_latitude
      t.decimal :start_location_longitude
      t.string :end_location_name
      t.decimal :end_location_latitude
      t.decimal :end_location_longitude
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
