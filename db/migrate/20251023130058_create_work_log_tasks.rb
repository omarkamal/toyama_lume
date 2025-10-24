class CreateWorkLogTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :work_log_tasks do |t|
      t.references :work_log, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.integer :duration_minutes
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
