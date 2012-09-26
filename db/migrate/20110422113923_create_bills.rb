class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.integer :portal_id
      t.string :name
      t.float :amount
      t.string :bill_type
      t.text :description
      t.date :due
      t.string :status, :default => "UnPaid"
      t.boolean :is_archived, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
