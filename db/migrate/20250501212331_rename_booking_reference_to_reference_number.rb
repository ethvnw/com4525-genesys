class RenameBookingReferenceToReferenceNumber < ActiveRecord::Migration[7.0]
  def change
    rename_column :booking_references, :booking_reference, :reference_number
    rename_column :ticket_links, :ticket_link, :link
  end
end
