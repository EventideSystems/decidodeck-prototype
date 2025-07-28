class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_current_workspace

  def pundit_user
    UserContext.new(current_user, current_workspace)
  end

  protected

  def current_workspace
    @current_workspace
  end
  helper_method :current_workspace

  def current_account
    current_workspace&.account
  end
  helper_method :current_account

  private

  def set_current_workspace
    return unless current_user && current_user.available_workspaces.any?

    # Try to get workspace from session first (for workspace switching)
    if session[:current_workspace_id].present?
      @current_workspace = current_user.available_workspaces.find_by(id: session[:current_workspace_id])
    end

    # Fallback to user's first workspace if no session workspace or if workspace not found
    @current_workspace ||= current_user.workspaces.first

    # Update session to track current workspace
    session[:current_workspace_id] = @current_workspace&.id
  end

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
