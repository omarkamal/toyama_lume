class AddIpAddressToWorkLogs < ActiveRecord::Migration[8.1]
  def change
    add_column :work_logs, :ip_address, :string
  end
end
