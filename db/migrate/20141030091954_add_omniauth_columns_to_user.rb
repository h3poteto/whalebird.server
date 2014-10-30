class AddOmniauthColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :uid, :string, null: false, default: "", after: :email
    add_column :users, :provider, :string, null: false, default: "", after: :uid
    add_column :users, :name, :string, after: :provider
    add_column :users, :oauth_token, :string, after: :name
    add_column :users, :oauth_token_secret, :string, after: :oauth_token
    add_column :users, :screen_name, :string, after: :name

    add_index :users, [:uid, :provider], unique: true
  end
end
