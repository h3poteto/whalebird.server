class AddColumnUserstreamToUsers < ActiveRecord::Migration
  def change
    add_column :users, :userstream, :boolean, default: false, null: false, after: :oauth_token_secret
  end
end
