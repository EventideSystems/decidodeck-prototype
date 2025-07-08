class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :invite,
      keys: [
        :email,
        :name,
        :system_role,
        { workspaces_users_attributes: %i[workspace_id workspace_role] }
      ]
    )
  end
end
