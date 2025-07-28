class UserPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      if workspace_admin?(user_context.workspace) || system_admin?
        base_scope
      else
        base_scope.where(invitation_token: nil)
      end
    end

    def base_scope
      scope.joins(:workspaces_users).where("workspaces_users.workspace_id" => current_workspace.id)
    end
  end

  def invite?
    admin? || account_owner?
  end
end
