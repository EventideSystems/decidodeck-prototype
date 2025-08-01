# frozen_string_literal: true

class ApplicationPolicy
  include PolicyHelpers

  class Scope
    include PolicyHelpers

    attr_reader :user_context, :scope

    def initialize(user_context, scope)
      @user_context = user_context
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end
  end

  attr_reader :user_context, :record

  def initialize(user_context, record)
    @user_context = user_context
    @record       = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def account_owner?
    user_context.account.owner == user_context.user
  end
end
