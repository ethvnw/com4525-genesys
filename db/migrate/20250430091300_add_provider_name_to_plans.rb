class AddProviderNameToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :provider_name, :string
  end
end
