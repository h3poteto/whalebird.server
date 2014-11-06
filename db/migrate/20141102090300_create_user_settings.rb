class CreateUserSettings < ActiveRecord::Migration
  def change
    create_table :user_settings do |t|
      t.integer :user_id
      t.boolean :notification, default: true, null: false
      t.boolean :reply, default: true, null: false
      t.boolean :favorite, defualt: false, null: false
      t.boolean :direct_message, default: false, null: false
      t.boolean :retweet, default: false, null: false
      t.string  :device_token

      t.timestamps
    end
  end
end
