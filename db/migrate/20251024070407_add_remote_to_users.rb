class AddRemoteToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :remote, :boolean, default: false, null: false
  end
end
