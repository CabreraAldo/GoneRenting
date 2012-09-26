class Bill < ActiveRecord::Base
  belongs_to :portal

  has_many :bill_users , :dependent => :destroy
  has_many :users, :through => :bill_users, :dependent => :destroy

  validates_presence_of :name, :amount,:due
  

  

  def send_bill_added_notification(creator,user,portal,bill,amount_due)
    Notifier.deliver_bill_added_notification(creator,user,portal,bill,amount_due)
  end

end
