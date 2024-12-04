class AddEmailCountryToRegistrations < ActiveRecord::Migration[7.0]
  def change
    add_column :registrations, :email, :string
    add_column :registrations, :country_code, :string
  end
end
