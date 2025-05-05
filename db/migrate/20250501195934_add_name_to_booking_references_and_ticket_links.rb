class AddNameToBookingReferencesAndTicketLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :booking_references, :name, :string
    add_column :ticket_links, :name, :string
  end
end
