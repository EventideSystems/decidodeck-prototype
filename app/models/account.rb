class Account < ApplicationRecord
  include Discard::Model
  has_logidze

  has_many :workspaces, dependent: :destroy
end
