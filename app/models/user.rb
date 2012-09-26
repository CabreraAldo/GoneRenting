class User < ActiveRecord::Base
  acts_as_authentic do |c|
    #    c.validate_password_field = false
    #    c.crypted_password_field = false
  end
  FACEBOOK_SCOPE = 'email,user_birthday'


  has_many :role_user
  has_many :roles , :through=>:role_user
  has_many :portals
  has_many :tasks
  has_many :invite_tokens
  has_many :invited_portals, :through => :invite_tokens, :source => "portal"
  has_many :bill_users , :dependent => :destroy
  has_many :bills, :through => :bill_users, :dependent => :destroy
  has_many :comments


  def due_bills(portal)
    self.bill_users.find(:all, :conditions => ["(status=? OR status=?) AND portal_id=?", 'UnPaid', 'Over Due', portal.id])
  end

  def all_bills(portal)
    self.bill_users.find(:all, :conditions => ["portal_id=?", portal.id])
  end

  def has_role?(role_in_question)
    self.roles.each do |r|
      if r.name == role_in_question
        return true
      end
    end
    return false
  end

  def bill_user(bill)
    bill_user_object = BillUser.find_by_bill_id_and_user_id(bill.id, self.id)
    bill.id.nil? ? BillUser.new : bill_user_object.nil? ? BillUser.new : bill_user_object
  end
  
  def can_delete?(portal)
    self.id == portal.user_id
  end
  
  def before_connect(facebook_session)
    self.first_name = facebook_session.first_name
    self.last_name = facebook_session.last_name
    self.email = facebook_session.email
    self.gender = facebook_session.gender
    self.username = "#{facebook_session.first_name}.#{facebook_session.last_name}"
    self.password = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{self.username}--")[0,6]
    self.password_confirmation = self.password
    self.active = true

    # Set other tokens
    self.single_access_token = Authlogic::Random.friendly_token
    self.perishable_token = Authlogic::Random.friendly_token
    reset_persistence_token
  end

  def self.new_or_find_by_facebook_oauth_access_token(access_token, options = {})
    user = User.find_by_facebook_oauth_access_token(access_token)
    if user.blank?
      #code to create new user here
    end
    user
  end

  def active?
    active
  end

  def activate!
    self.active = true
    save
  end

  def deactivate!
    self.active = false
    save
  end

  def send_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def send_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end

  def email_address_with_name
    "#{self.name} <#{self.email}>"
  end

  def send_forgot_password!
    deactivate!
    reset_perishable_token!
    Notifier.deliver_forgot_password(self)
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end

  def get_all_portals
    self.portals + self.invited_portals
  end
end
