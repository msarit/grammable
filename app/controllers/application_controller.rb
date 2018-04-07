class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def render_not_found(status=:not_found)
    render plain: "#{status.to_s.titleize}", status: status
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname])
  end
end
