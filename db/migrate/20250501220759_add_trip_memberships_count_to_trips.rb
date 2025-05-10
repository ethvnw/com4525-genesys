class AddTripMembershipsCountToTrips < ActiveRecord::Migration[7.0]
  def change
    add_column :trips, :trip_memberships_count, :integer, default: 0, null: false
  end
end
