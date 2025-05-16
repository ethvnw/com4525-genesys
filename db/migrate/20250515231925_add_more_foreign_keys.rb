class AddMoreForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :plans, :trips
  end
end
