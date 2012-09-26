class AddAlertsColumnsInBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :alert_24_hours, :boolean, :default => false
    add_column :bills, :alert_bill_due, :boolean, :default => false
  end

  def self.down
    remove_column :bills, :alert_24_hours
    remove_column :bills, :alert_bill_due
  end
end
