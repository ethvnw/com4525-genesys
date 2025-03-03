class CreateTripMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :trip_memberships do |t|
      t.boolean :is_invite_accepted, default: false
      t.string :user_display_name

      t.belongs_to :trip
      t.belongs_to :user

      t.timestamps
    end
  end
end
