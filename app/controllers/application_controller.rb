class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_current_account

  protected

  def current_account
    @current_account
  end
  helper_method :current_account

  private

  def set_current_account
    return unless user_signed_in?

    # Try to get account from session first (for account switching)
    if session[:current_account_id].present?
      @current_account = current_user.accounts.find_by(id: session[:current_account_id])
    end

    # Fallback to user's first account if no session account or if account not found
    @current_account ||= current_user.accounts.first

    # Update session to track current account
    session[:current_account_id] = @current_account&.id
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
