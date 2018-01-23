class ApplicationController < ActionController::Base
  include TheRole::Controller
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_raven_context

  def role_access_denied
    access_denied_method = TheRole.config.access_denied_method
    return send(access_denied_method) if access_denied_method && respond_to?(access_denied_method)
    the_role_default_access_denied_response
  end

  protected

  def configure_permitted_parameters
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :role_id])
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

	def the_role_default_access_denied_response
    access_denied_msg = t(:access_denied, scope: :the_role)

    if request.xhr?
      render json: {
        errors: { the_role: [ access_denied_msg ] },

        controller_name:      controller_path,
        action_name:          action_name,
        has_access_to_action: current_user.try(:has_role?, controller_path, action_name),

        current_user: { id: current_user.try(:id) }

        # owner_check_object: {
        #   owner_check_object_id:    @owner_check_object.try(:id),
        #   owner_check_object_class: @owner_check_object.try(:class).try(:to_s)
        # },

        # has_access_to_object: current_user.try(:owner?, @owner_check_object)
      }, status: 401
    else
      # When the user paste non authorized URL in browser the REFERER is blank and application crash
      if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
        # redirect_to root_path, flash: { error: access_denied_msg }
        render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
      else
      	render :file => "#{Rails.root}/public/403.html", :status => 403, :layout => false
        # redirect_to root_path, flash: { error: access_denied_msg }
      end
    end
  end
end
