class AddOrderToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :order, :integer, default: 0
  end
end
