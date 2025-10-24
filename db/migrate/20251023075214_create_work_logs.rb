class CreateWorkLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :work_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :punch_in
      t.datetime :punch_out
      t.decimal :location_lat
      t.decimal :location_lng
      t.string :mood

      t.timestamps
    end
  end
end
