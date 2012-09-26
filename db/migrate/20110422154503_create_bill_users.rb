class CreateBillUsers < ActiveRecord::Migration
  def self.up
    create_table :bill_users do |t|
      t.integer :bill_id
      t.integer :user_id
      t.integer :portal_id
      t.float :amount_due, :default => 0.0
      t.float :amount_paid, :default => 0.0
      t.string :status ,:default => "UnPaid"

      t.timestamps
    end
  end

  def self.down
    drop_table :bill_users
  end
end
