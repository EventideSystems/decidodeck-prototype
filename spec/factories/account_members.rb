# == Schema Information
#
# Table name: account_members
#
#  id         :uuid             not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_account_members_on_account_id              (account_id)
#  index_account_members_on_account_id_and_user_id  (account_id,user_id) UNIQUE
#  index_account_members_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :account_member do
  end
end
