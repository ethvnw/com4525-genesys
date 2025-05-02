class AddIsBackupPlanToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :is_backup_plan, :boolean, default: false, null: false
  end
end
