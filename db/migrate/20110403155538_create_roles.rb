class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name

      t.timestamps
    end

    r1 = Role.new
    r1.name = "Admin"
    r1.save

    r2 = Role.new
    r2.name = "Subadmin"
    r2.save

    r3 = Role.new
    r3.name = "User"
    r3.save

  end

  def self.down
    drop_table :roles
  end
end
