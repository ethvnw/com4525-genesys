class AddTitleToScannableTickets < ActiveRecord::Migration[7.0]
  def change
    add_column :scannable_tickets, :title, :string
  end
end
