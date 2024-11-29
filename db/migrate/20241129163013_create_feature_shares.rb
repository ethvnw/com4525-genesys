class CreateFeatureShares < ActiveRecord::Migration[7.0]
  def change
    create_table :feature_shares do |t|
      t.string(:media)
      t.datetime(:timestamp)
    end
  end
end
