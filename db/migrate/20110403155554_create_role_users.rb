class CreateRoleUsers < ActiveRecord::Migration
  def self.up
    create_table :role_users, :id => false do |t|
      t.integer :user_id
      t.integer :role_id

      t.timestamps
    end

    user = User.new
    user.username = "Admin"
    user.email = "1mr.hamid.raza@gmail.com"
    user.roles << Role.find_by_name("Admin")
    user.password = "admin123"
    user.password_confirmation = "admin123"
    user.created_at = DateTime.now
    user.updated_at = DateTime.now
    user.save
  end

  def self.down
    drop_table :role_users
  end


end
