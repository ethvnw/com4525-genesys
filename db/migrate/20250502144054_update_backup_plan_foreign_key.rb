class UpdateBackupPlanForeignKey < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :plans, column: :backup_plan_id
    add_foreign_key :plans, :plans, column: :backup_plan_id, on_delete: :nullify
  end
end
