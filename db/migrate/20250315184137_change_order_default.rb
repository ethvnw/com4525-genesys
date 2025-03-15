class ChangeOrderDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :questions, :order, to: -1
    change_column_default :reviews, :order, to: -1
    change_column_default :questions, :is_hidden, to: true
    change_column_default :reviews, :is_hidden, to: true
  end
end
