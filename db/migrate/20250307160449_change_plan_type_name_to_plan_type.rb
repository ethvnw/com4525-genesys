class ChangePlanTypeNameToPlanType < ActiveRecord::Migration[7.0]
  def change
    rename_column :plans, :type, :plan_type
  end
end
