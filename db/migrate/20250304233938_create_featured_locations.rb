class CreateFeaturedLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :featured_locations do |t|
      t.string :name
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
