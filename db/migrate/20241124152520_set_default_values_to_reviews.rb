class SetDefaultValuesToReviews < ActiveRecord::Migration[7.0]
  def change
    change_column_default :reviews, :is_hidden, from: nil, to: true
    change_column_default :reviews, :engagement_counter, from: nil, to: 0
    change_column_default :reviews, :order, from: nil, to: 0
  end
end
