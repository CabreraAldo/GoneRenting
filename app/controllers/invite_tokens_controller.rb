class InviteTokensController < ApplicationController
  before_filter :get_portal
	before_filter :get_invite_token, :except => [:new, :create, :update, :destroy]

  def new
    @invite_token = InviteToken.new
    @invite_token.portal_id = @portal.id
  end

  def create
    @invite_token = @portal.invite_tokens.new(params[:invite_token])
    if @invite_token.save
      flash[:notice] = "User is invited successfully!"
			Notifier.deliver_invite_token(current_user, @invite_token, @portal)
      redirect_to new_invite_token_url(:portal_id => @portal.id)
    else
      flash[:notice] = "User was not invited successfully!"
      render :action => 'new'      
    end		
  end

  def destroy
    @invite_token = InviteToken.find params[:id]
    if @invite_token.destroy
      flash[:notice] = "Invited User delete successfully!"      
    end
    redirect_to new_invite_token_path(:portal_id => @portal.id)
  end
  
  def accept
	  @portal = Portal.find(@invite_token.portal_id)
    puts "================================"
    puts @portal.inspect
    puts "================================"
    puts @invite_token.inspect
    
    # already has access?
    if @portal.invitees.include?(current_user)
      
      flash[:notice] = "You already have access/permissions for this portal."
      redirect_to dashboard_url(:portal_name => @portal.name, :id => @portal.id )
      return
    else
      puts current_user.inspect     
      @invite_token.user_id = current_user.id
			@invite_token.is_accepted = true
			@invite_token.token = ""
			@invite_token.save
    end
	end

	# Accept using currently logged in user (if available)
	def show
	  if !current_user #if no current user, default to the "register new user" page
	  	@user = User.new
	  	render :action => 'new_user'
	  	return
	  end	  
	end

	#Accept as new user
	def new_user
	  @user = User.new	  
	end

	#Accept as new user
	def create_user
    @user = User.new(params[:user])
    @user.activate!
    if @user.save
      current_user_session.destroy
			@user_session = UserSession.create!(:username => @user.username, :password => @user.password)

      puts "00000000000000000000000000000000000000"
      puts @user_session.inspect

      redirect_to accept_invite_token_path(:portal_id => @portal.id, :token => @invite_token.token)
    else		  
      render :action => :new_user
    end
	end

	#Accept as a different user
	def login_user
	  @user_session = UserSession.new	  
	end

	#Verify login
	def create_user_session
		@user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to accept_invite_token_path(:portal_id => @portal.id, :token => @invite_token.token)
    else      
      render :action => :login_user
    end
	end


  private

  def get_invite_token
  	if InviteToken.find_by_token(params[:token]) && InviteToken.find_by_token(params[:token]).is_accepted == false
      @invite_token = InviteToken.find_by_token(params[:token])      
	  else
      flash[:error] = "That invitation is no longer valid."
      redirect_to root_url
      return
	  end
	end

  def get_portal
    @portal = Portal.find params[:portal_id]
  end
  
end
