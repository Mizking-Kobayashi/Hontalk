class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # サインアップ時に unique_name を許可
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :unique_name, :name, :avatar ])
    # アカウント更新時に unique_name を許可
    devise_parameter_sanitizer.permit(:account_update, keys: [ :unique_name, :name, :avatar ])
  end
end
