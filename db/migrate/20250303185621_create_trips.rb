class CreateTrips < ActiveRecord::Migration[7.0]
  def change
    create_table :trips do |t|
      t.string :title, null: false
      t.string :description
      t.string :location_name
      t.decimal :location_lat
      t.decimal :location_lng
      t.timestamp :start_date
      t.timestamp :end_date

      t.timestamps
    end
  end
end
