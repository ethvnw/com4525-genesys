class AddTripCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :trips_count, :integer, default: 0, null: false
  end
end
