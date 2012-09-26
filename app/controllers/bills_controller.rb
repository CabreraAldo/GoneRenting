class BillsController < ApplicationController
  before_filter :get_portal
  
  def index
    @bills = @portal.bills
  end

  def new
		@bill = Bill.new    
	end

  def edit
    @bill = Bill.find(params[:bill_id])
    @portal_users = @portal.all_users
  end

  def portal_bills
    @bills = @portal.bills
  end

  def fetch_portal_users
    @portal_users = @portal.all_users

    @bill = params[:bill_id].nil? ? Bill.new : Bill.find(params[:bill_id])

    if params[:fetch_user] and params[:fetch_user] == "true"
      render :update do |page|
        page << "if ($('#portal_users').is(':hidden')) {"
        page[:portal_users].replace_html :partial => "portal_users", :locals => {:portal_users => @portal_users, :portal => @portal, :bill => @bill}
        page << "$('#portal_users').slideDown('slow');"
        page << "}"
      end
    else
      render :update do |page|
        page["portal_users"].replace_html ""        
      end
    end
  end

	def create        
		@bill = Bill.new(params[:bill])       
    @all_users = @portal.all_users    
    if @bill.save
      if params[:bill_division] and params[:bill_division] == "different"        
        @all_users.each do |user|
          amount_paid = params["bill_user"]["amount_paid_#{user.id}"].to_f
          amount_due  = params["bill_user"]["amount_due_#{user.id}"].to_f
          @bill_user = BillUser.new
          @bill_user.bill_id = @bill.id
          @bill_user.user_id = user.id
          @bill_user.portal_id = @portal.id
          @bill_user.amount_due = amount_due
          @bill_user.amount_paid = amount_paid
          @bill_user.status = status(amount_paid,amount_due,@bill)
          @bill_user.save
        end
      elsif params[:bill_division] and params[:bill_division] == "equal"
        @partial_bill_for_each_user = (@bill.amount.to_f/@all_users.size.to_f).round(2)
        @all_users.each do |user|
          @bill_user = BillUser.new
          @bill_user.bill_id = @bill.id
          @bill_user.user_id = user.id
          @bill_user.portal_id = @portal.id
          @bill_user.amount_due = @partial_bill_for_each_user
          @bill_user.amount_paid = 0.to_f
          @bill_user.status = status(@bill_user.amount_paid,@bill_user.amount_due,@bill)
          @bill_user.amount_due = @partial_bill_for_each_user
          @bill_user.save
        end
      end
      if params[:notification] and params[:notification] == "yes"
        @all_users.each do |user|
          amount_due = BillUser.find_by_bill_id_and_user_id(@bill.id, user.id).amount_due
          @bill.send_bill_added_notification(current_user,user,@portal,@bill,amount_due)
        end
      end
      flash[:notice]= "Bill saves successfully!"
      return redirect_to bills_path(:id => @portal.id)    
    else
      flash[:alert] = "Bill was not save successfully!"
      return render :action => "new"
    end
  end

  def all_bills_of_user
  end

  def update
    @bill = Bill.find(params[:bill_id])
    @check_bill = Bill.new(params[:bill])
    
    if @check_bill.valid?
      
      @bill.update_attributes(params[:bill])
      
      
      @all_users = @portal.all_users
      @all_users.each do |user|
        amount_paid = params["bill_user"]["amount_paid_#{user.id}"].to_f
        amount_due  = params["bill_user"]["amount_due_#{user.id}"].to_f
        @bill_user = BillUser.find_by_bill_id_and_user_id(@bill.id, user.id)
        if @bill_user
          @bill_user.amount_due = amount_due
          @bill_user.amount_paid = amount_paid
          @bill_user.status = status(amount_paid,amount_due,@bill)
          @bill_user.save
        else
          @bill_user = BillUser.new
          @bill_user.bill_id = @bill.id
          @bill_user.user_id = user.id
          @bill_user.portal_id = @portal.id
          @bill_user.amount_due = amount_due
          @bill_user.amount_paid = amount_paid
          @bill_user.status = status(amount_paid,amount_due,@bill)
          @bill_user.save
        end        
      end
      @bill.update_attribute("status",accumulative_bill_status(@bill))
      flash[:notice]= "Bill was updated successfully!"
      return redirect_to portal_bills_path(:id => @portal.id)
    else      
      @portal_users = @portal.all_users
      flash[:alert] = "Bill was not udpated successfully!"
      return render :action => "edit"
    end
  end

  def destroy
    @bill = Bill.find(params[:bill_id])
    if @bill.destroy
      flash[:notice] = "Bill was deleted Successfully!"
    else
      flash[:alert] = "Bill was not deleted Successfully!"
    end
    return redirect_to portal_bills_path(:id => @portal.id)
  end

  def status(amount_paid,amount_due,bill)
    (DateTime.now > bill.due and amount_paid < amount_due) ? "Over Due" : amount_paid < amount_due ? "UnPaid" : "Paid"
  end

  def accumulative_bill_status(bill)
    (DateTime.now > bill.due and calculate_each_user_status(bill) == "UnPaid") ?  "Over Due" : calculate_each_user_status(bill)
  end

  def calculate_each_user_status(bill)
    bill_users_statuses = BillUser.find_all_by_bill_id(bill.id).collect(&:status)
    bill_users_statuses.blank? ? "UnPaid" : bill_users_statuses.include?("UnPaid") ? "UnPaid" : bill_users_statuses.include?("Over Due") ? "Over Due" : "Paid"
  end

  def get_portal
    @portal = Portal.find params[:id]
  end
end
