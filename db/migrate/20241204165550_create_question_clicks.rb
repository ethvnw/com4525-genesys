class CreateQuestionClicks < ActiveRecord::Migration[7.0]
  def change
    create_table :question_clicks do |t|

      t.timestamps

      t.belongs_to :question
      t.belongs_to :registration
    end
  end
end
