class AddInviteAcceptedDateToTripMemberships < ActiveRecord::Migration[7.0]
  def change
    add_column :trip_memberships, :invite_accepted_date, :datetime
  end
end
