class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_devise_parameters, if: :devise_controller?


  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      flash[:error] = "Not authorized to view this page"
      session[:user_return_to] = nil
      redirect_to root_url

    else              
      flash[:error] = "You must first login to view this page"
      session[:user_return_to] = request.url
      redirect_to "/users/sign_in"
    end 
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
  end


  def market_open
    hr = Time.now.utc.strftime("%H").to_i
    hr.between?(16,23)
  end

  def happy_hour
    hr = Time.now.utc.strftime("%H").to_i
    hr == 23
  end


	protected

  def configure_devise_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:refid, :email, :password, :password_confirmation, :username) }
  end

  private

  def after_sign_in_path_for(resource)
    if current_user.tosdate.nil?
      dashboard_accept_tos_path
    elsif current_user.balances.btc.first_or_create(curtype: "crypto").amount.to_f == 0
      dashboard_deposit_path
    else
      dashboard_path
    end
  end


  def after_sign_out_path_for(resource_or_scope)
   root_path
  end


end
