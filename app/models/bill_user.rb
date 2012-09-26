class BillUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :bill

  def self.send_alert_when_24_hours_left
    @bills = Bill.find(:all, :conditions => ["Datediff(CURDATE(), due) = ? AND Datediff(CURDATE(), due) = ? AND alert_24_hours = ? ", -1, 0, false ] )
    @bills.each do |bill|
      bill.bill_users.find_all_by_status("Unpaid").each do |bill_user|
        Notifier.deliver_send_alert_when_24_hours_left(bill_user)
      end
      bill.update_attribute("alert_24_hours", true)
    end    
  end

  def self.send_alert_when_bill_is_due
    @bills = Bill.find(:all, :conditions => ["Datediff(CURDATE(), due) >= ? AND alert_bill_due = ? ", 1, false ] )

    @bills.each do |bill|
      bill.bill_users.find_all_by_status("Over Due").each do |bill_user|
        Notifier.deliver_send_alert_when_bill_is_due(bill_user)
      end
      bill.update_attribute("alert_bill_due", true)
    end
  end
end
