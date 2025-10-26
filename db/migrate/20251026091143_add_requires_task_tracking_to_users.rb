class AddRequiresTaskTrackingToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :requires_task_tracking, :boolean, default: false, null: false
  end
end
