class AccountMember < ApplicationRecord
  belongs_to :user, inverse_of: :account_members
  belongs_to :account, inverse_of: :account_members
end
