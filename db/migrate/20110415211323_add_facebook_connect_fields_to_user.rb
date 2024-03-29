class AddFacebookConnectFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string
    add_column :users, :facebook_uid, :string
    add_column :users, :facebook_access_token, :string
  end

  def self.down
    remove_column :users, :facebook_access_token
    remove_column :users, :facebook_uid
  end
end
