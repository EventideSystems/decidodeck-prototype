class PersonPolicy < ApplicationPolicy # rubocop:disable Style/Documentation
  class Scope < Scope # rubocop:disable Style/Documentation
    def resolve
      current_account.people
    end
  end
end
