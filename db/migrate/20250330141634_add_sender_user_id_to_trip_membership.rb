class AddSenderUserIdToTripMembership < ActiveRecord::Migration[7.0]
  def change
    add_column :trip_memberships, :sender_user_id, :bigint
    add_index :trip_memberships, :sender_user_id
    add_foreign_key :trip_memberships, :users, column: :sender_user_id
  end
end
