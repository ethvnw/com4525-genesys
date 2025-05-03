class CreateReferrals < ActiveRecord::Migration[7.0]
  def change
    create_table :referrals do |t|
      t.references :sender_user, null: false, foreign_key: { to_table: :users }
      t.string :receiver_email

      t.timestamps
    end
  end
end
