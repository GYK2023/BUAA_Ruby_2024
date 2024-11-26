class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_cart
  helper_method :current_cart
  private
  def current_cart
    @current_cart ||= Cart.find_or_create_by(id: session[:cart_id]) do |cart|
      cart.user = current_user if user_signed_in?
    end
    session[:cart_id] ||= @current_cart.id
    @current_cart
  end

  def set_cart
    if user_signed_in?
      @cart = current_user.cart || current_user.create_cart
    else
      @cart = Cart.find_by(id: session[:cart_id]) || Cart.create
      session[:cart_id] ||= @cart.id
    end
  end
  
  protected
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: [:username, :password]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end