class AddCarryForwardToWorkLogTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :work_log_tasks, :carry_forward, :boolean, default: false
  end
end
