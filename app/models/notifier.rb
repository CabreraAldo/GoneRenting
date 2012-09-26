class Notifier < ActionMailer::Base
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          "Binary Logic Notifier "
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)
  end
  
  def activation_instructions(user)
    from          "GoneRenting <noreply@gonerenting.com>"

    @account_activation_url = activate_account_url(user.perishable_token)

    subject       "Activation Instructions"
    recipients    user.email
    sent_on       Time.now
    body          :account_activation_url => activate_account_url(user.perishable_token)
    content_type  "text/html"


  end

  def bill_added_notification(creator,user,portal,bill,amount_due, sent_at = Time.now)
    @from = "#{creator.username}<no-reply@gonerenting.com>"
    @subject = "New Bill added: #{bill.name}"
    @bill = bill
    @portal = portal
    @user = user
    @creator = creator
    @amount_due = amount_due
    @recipients = @user.email
    @sent_on = sent_at
    @body["title"] = "New Bill added: #{bill.name}"
    content_type  "text/html"
  end

  def send_alert_when_24_hours_left(bill_user, sent_at = Time.now)
    @from = "<no-reply@gonerenting.com>"
    @subject = "#{bill_user.bill.name} - Is Due in 24 hours!"
    @bill = bill_user.bill
    @user = bill_user.user
    @portal = bill_user.bill.portal
    @amount_due = bill_user.amount_due
    @creator = @portal.user
    @recipients = @user.email
    @sent_on = sent_at
    @body["title"] = "#{bill_user.bill.name} - Is Due in 24 hours!"
    content_type  "text/html"
  end

  def send_alert_when_bill_is_due(bill_user, sent_at = Time.now)
    @from = "<no-reply@gonerenting.com>"
    @subject = "#{bill_user.bill.name} - Is Over Due!"
    @bill = bill_user.bill
    @user = bill_user.user
    @portal = bill_user.bill.portal
    @amount_due = bill_user.amount_due
    @creator = @portal.user
    @recipients = @user.email
    @sent_on = sent_at
    @body["title"] = "#{bill_user.bill.name} - Is Over Due!"
    content_type  "text/html"
    content_type  "text/html"
  end


  def activation_confirmation(user)
    from          "GoneRenting <noreply@gonerenting.com>"
    subject       "Activation Confirmation"
    recipients    user.email
    sent_on       Time.now
    content_type "text/html"

  end

  def forgot_password(user)

    subject       "Password Reset Instructions"
    from          "GoneRenting <noreply@gonerenting.com>"
    recipients    user.email
    sent_on       Time.now
    body          :reset_password_link => reset_password_url(user.perishable_token)    
  end

  def invite_token(user_who_invite, invite_token, portal, sent_at = Time.now)
    @user = user_who_invite
    @invite_token = invite_token
    @portal = portal

    @subject = "You've been invited to a portal on GoneRenting."
    @recipients = @invite_token.email

    @from = "#{user_who_invite.username}<notifications@gonerenting.com>"
    
    @url = "http://#{SITE_URL}#{show_invite_token_path(:portal_id =>@portal.id ,:token => @invite_token.token)}"

    @sent_on = sent_at
    @body["title"] = "You've been invited to a portal on GoneRenting."
    content_type "text/html"
  end

end
