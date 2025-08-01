# == Schema Information
#
# Table name: accounts
#
#  id              :uuid             not null, primary key
#  description     :text
#  discarded_at    :datetime
#  log_data        :jsonb
#  max_users       :integer          default(3)
#  max_workspaces  :integer          default(1)
#  name            :citext           not null
#  plan            :string           default("free"), not null
#  plan_expires_at :datetime         default(2014-01-01 00:00:00.000000000 UTC +00:00), not null
#  status          :string           default("active"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :uuid             not null
#
# Indexes
#
#  index_accounts_on_discarded_at  (discarded_at)
#  index_accounts_on_name          (name) UNIQUE
#  index_accounts_on_owner_id      (owner_id)
#  index_accounts_on_plan          (plan)
#  index_accounts_on_status        (status)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
class Account < ApplicationRecord
  has_discard
  has_logidze

  belongs_to :owner, class_name: "User", foreign_key: :owner_id, inverse_of: :accounts

  has_many :workspaces, dependent: :destroy
  has_many :stakeholders, class_name: "Stakeholders::Base", dependent: :destroy
  has_many :account_members, dependent: :destroy
  has_many :members, through: :account_members, source: :user, inverse_of: :accounts
  has_many :people, class_name: "Person", dependent: :destroy

  def stakeholders_individuals
    stakeholders.where(type: "Stakeholders::Individual")
  end

  def stakeholders_organizations
    stakeholders.where(type: "Stakeholders::Organization")
  end

  def display_name
    name
  end

  def max_members_reached?
    members.count >= max_users
  end
end
