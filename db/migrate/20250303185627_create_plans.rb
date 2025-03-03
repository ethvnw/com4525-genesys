class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.belongs_to :trip
      t.string :title, null: false
      t.string :type, null: false
      t.string :start_location_name
      t.decimal :start_location_lat
      t.decimal :start_location_lng
      t.string :end_location_name
      t.decimal :end_location_lat
      t.decimal :end_location_lng
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
