class CreateTicketLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_links do |t|
      t.belongs_to :plan
      t.string :ticket_link, null: false

      t.timestamps
    end
  end
end
