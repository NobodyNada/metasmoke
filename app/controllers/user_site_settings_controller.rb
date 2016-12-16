class UserSiteSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin, :only => [:for_user]
  before_action :set_preference, :only => [:edit, :update, :destroy]
  before_action :verify_authorized, :only => [:edit, :update, :destroy]

  def index
    @preferences = UserSiteSetting.where(:user => current_user)
  end

  def for_user
    @preferences = UserSiteSetting.where(:user_id => params[:user])
  end

  def new
    @preference = UserSiteSetting.new
  end

  def create
    @preference = UserSiteSetting.new preference_params
    @preference.sites = params[:user_site_setting][:sites].map{ |i| Site.find i.to_i if i.present? }.compact

    if @preference.save
      flash[:success] = "Saved your preferences."
      redirect_to url_for(:controller => :user_site_settings, :action => :index)
    else
      render :new, :status => 422
    end
  end

  def edit
  end

  def update
    @preference.sites = params[:user_site_setting][:sites].map{ |i| Site.find i.to_i if i.present? }.compact
    if @preference.update preference_params
      flash[:success] = "Saved your preferences."
      redirect_to url_for(:controller => :user_site_settings, :action => :index)
    else
      render :edit, :status => 422
    end
  end

  def destroy
    if @preference.destroy
      flash[:success] = "Removed your preferences."
    else
      flash[:danger] = "Failed to remove your preferences - contact a developer to find out why."
    end
    redirect_to url_for(:controller => :user_site_settings, :action => :index)
  end

  private
  def set_preference
    @preference = UserSiteSetting.find params[:id]
  end

  def preference_params
    params.require(:user_site_setting).permit(:max_flags)
  end

  def verify_authorized
    current_user.has_role?(:admin) || @preference.user == current_user
  end
end
