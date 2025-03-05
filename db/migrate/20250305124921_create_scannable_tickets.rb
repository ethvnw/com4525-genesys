class CreateScannableTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :scannable_tickets do |t|
      t.belongs_to :plan
      t.string :code, null: false
      t.integer :ticket_format, null: false

      t.timestamps
    end
  end
end
