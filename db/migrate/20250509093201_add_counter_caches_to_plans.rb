class AddCounterCachesToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :scannable_tickets_count, :integer, default: 0, null: false
    add_column :plans, :booking_references_count, :integer, default: 0, null: false
    add_column :plans, :ticket_links_count, :integer, default: 0, null: false
  end
end
