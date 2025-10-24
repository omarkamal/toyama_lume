class AddUserIdToWorkZones < ActiveRecord::Migration[8.1]
  def change
    add_column :work_zones, :user_id, :integer
    add_index :work_zones, :user_id
  end
end
