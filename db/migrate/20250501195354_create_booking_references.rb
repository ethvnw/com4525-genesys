class CreateBookingReferences < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_references do |t|
      t.string :booking_reference
      t.references :plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
