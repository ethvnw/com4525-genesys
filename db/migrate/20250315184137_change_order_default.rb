class ChangeOrderDefault < ActiveRecord::Migration[7.0]
  def change
    change_column :questions, :order, :integer, default: "-1", null: false
    change_column :reviews, :order, :integer, default: "-1", null: false
    change_column_default :questions, :is_hidden, to: true
    change_column_default :reviews, :is_hidden, to: true
  end
end
