class UserPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      admin? ? scope.all : current_account.members
    end
  end

  def invite?
    admin? || account_owner?
  end

  def update?
    admin? || account_owner? || record == user_context.user
  end
end
