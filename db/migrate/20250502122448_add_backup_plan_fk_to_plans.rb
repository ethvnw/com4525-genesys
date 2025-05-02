class AddBackupPlanFkToPlans < ActiveRecord::Migration[7.0]
  def change
    add_reference :plans, :backup_plan, foreign_key: { to_table: :plans }, index: true
  end
end
