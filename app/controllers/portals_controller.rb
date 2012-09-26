class PortalsController < ApplicationController

  def index
  end

  def show
    @portal = Portal.find params[:id]
  end

  def new
    @portal = Portal.new
    6.times { @portal.amenities.build }
    5.times { @portal.avatars.build }
  end

  def edit
    @portal = Portal.find params[:id]
    (5.to_i - @portal.avatars.size.to_i).times { @portal.avatars.build }
    if params[:only_pictures_edit] and params[:only_pictures_edit] == "true"
      @only_pictures_edit = "true"
    end
  end

  def update
    @portal = Portal.find params[:id]
    if @portal.update_attributes(params[:portal])
      flash[:notice] = "Portal Updated successfully!"
      redirect_to homepage_url
    else
      flash[:alert] = "Portal was not updated successfully!"
      render :action => "edit"
    end
  end

  def create
    if current_user.portals.size < 3.to_i
      @portal = Portal.new(params[:portal])
      if @portal.save
        flash[:notice] = "Portal saved successfully!"
        redirect_to dashboard_url(:portal_name => @portal.name, :id => @portal.id )
      else
        flash[:alert] = "Portal was not saved successfully!"
        render :action => "new"
      end
    else
      flash[:alert] = "You have reached your limit of creating portals, please consult Administrator!"
      redirect_to homepage_url
    end
  end

  def destroy
    @portal = Portal.find(params[:id])
    if current_user.can_delete?(@portal)
      flash[:notice] = "Portal deleted successfully!"
      @portal.destroy
      redirect_to homepage_url
    else
      flash[:alert] = "You do not have rights to delete this portal"
      redirect_to dashboard_url(:portal_name => @portal.name, :id => @portal.id )
    end
  end
  
end
