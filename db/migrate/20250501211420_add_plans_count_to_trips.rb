class AddPlansCountToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :regular_plans_count, :integer, default: 0, null: false
    add_column :trips, :travel_plans_count, :integer, default: 0, null: false
  end
end
