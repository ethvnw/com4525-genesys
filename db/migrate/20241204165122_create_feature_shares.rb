class CreateFeatureShares < ActiveRecord::Migration[7.0]
  def change
    create_table :feature_shares do |t|
      t.string :media

      t.timestamps

      t.belongs_to :registration
      t.belongs_to :app_feature
    end
  end
end
