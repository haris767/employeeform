class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller? #Devise filters parameters during sign up and account update

   def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :active, :department_id, role_ids: [] ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :active, :department_id, role_ids: [] ])
  end
end
