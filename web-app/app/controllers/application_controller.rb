class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def default_url_options
    options = super
    options.merge!(host: ENV['APP_HOST']) if ENV['APP_HOST']
    options
  end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :role_id])
  end
end
