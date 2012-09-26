class CreatePortals < ActiveRecord::Migration
  def self.up
    create_table :portals do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :for_what

      t.timestamps
    end
  end

  def self.down
    drop_table :portals
  end
end
