class CreateUnreadCounts < ActiveRecord::Migration
  def change
    create_table :unread_counts do |t|
      t.integer :user_id
      t.integer :unread, null: false, default: 0

      t.timestamps
    end
  end
end
