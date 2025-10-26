class AddApprovedAtToLeaveRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :leave_requests, :approved_at, :datetime
  end
end
