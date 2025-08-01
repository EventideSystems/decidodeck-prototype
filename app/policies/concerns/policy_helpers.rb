# frozen_string_literal: true

module PolicyHelpers
  extend ActiveSupport::Concern

  included do
    delegate :user, :workspace, :account, to: :user_context, prefix: :current
    delegate :admin?, to: :user_context, prefix: false
  end
end
