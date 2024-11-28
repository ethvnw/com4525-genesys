class CreateAppFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :app_features do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
