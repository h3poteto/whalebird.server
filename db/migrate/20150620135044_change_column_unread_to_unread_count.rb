class ChangeColumnUnreadToUnreadCount < ActiveRecord::Migration
  def change
    change_column :unread_counts, :unread, :integer, default: 0, null: false
  end
end
