class AddPlansCountToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :plans_count, :integer, default: 0, null: false
  end
end
