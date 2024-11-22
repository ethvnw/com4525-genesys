class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.text :content
      t.integer :order
      t.boolean :is_hidden
      t.integer :engagement_counter

      t.timestamps
    end
  end
end
