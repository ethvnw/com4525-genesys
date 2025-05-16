class AddIndexing < ActiveRecord::Migration[7.0]
  def change
    add_index :trips, :start_date
    add_index :plans, :start_date
    add_index :trip_memberships, :created_at
    add_index :trip_memberships, :invite_accepted_date
  end
end
