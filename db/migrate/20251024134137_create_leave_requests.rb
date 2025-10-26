class CreateLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.boolean :half_day, default: false
      t.text :reason
      t.string :status, default: 'pending', null: false
      t.references :approved_by, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :leave_requests, :status
    add_index :leave_requests, [:user_id, :start_date]
    add_index :leave_requests, [:user_id, :status]
  end
end
