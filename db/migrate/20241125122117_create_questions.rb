class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question
      t.text :answer
      t.boolean :is_hidden
      t.integer :engagement_counter

      t.timestamps
    end
  end
end
