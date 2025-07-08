class Account < ApplicationRecord
  include Discard::Model
  has_logidze

  has_many :workspaces, dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: :owner_id, inverse_of: :accounts
end
