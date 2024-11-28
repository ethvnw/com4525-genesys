class CreateSubscriptionTiers < ActiveRecord::Migration[7.0]
  def change
    create_table :subscription_tiers do |t|
      t.string :name
      t.decimal :price_gbp
      t.string :discount_description
      t.string :terms_description

      t.timestamps
    end
  end
end
