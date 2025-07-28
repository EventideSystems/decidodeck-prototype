# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  admin                  :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  discarded_at           :datetime
#  email                  :citext           not null
#  encrypted_password     :string           not null
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invitations_count      :integer          default(0)
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  locale                 :string           default("en"), not null
#  log_data               :jsonb
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  status                 :string           default("active"), not null
#  time_zone              :string           default("UTC"), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_discarded_at          (discarded_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by            (invited_by_type,invited_by_id)
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_name                  (name)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_status                (status)
#
class User < ApplicationRecord
  has_discard
  has_logidze

  enum :status, { active: "active",  suspended: "suspended", archived: "archived" }

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_many :accounts, dependent: :destroy, inverse_of: :owner, foreign_key: :owner_id
  has_many :account_members, dependent: :destroy
  has_many :workspaces, through: :accounts
  has_many :memberships, through: :account_members, source: :account
  has_many :member_workspaces, through: :memberships, source: :workspaces

  # Using virtual attributes to disable tracking of sign-in IPs (for privacy reasons)
  # If you need to track IPs, you can remove these lines and use Devise's default behavior.
  # However, ensure that you comply with privacy regulations regarding IP tracking. You will also need to
  # add `current_sign_in_ip` and `last_sign_in_ip` to the database schema if you want to track them.
  attr_accessor :current_sign_in_ip, :last_sign_in_ip

  def active_for_authentication?
    super && active? && !discarded?
  end

  def available_workspaces
    member_workspace_ids = memberships.map(&:workspaces).flatten.map(&:id)
    owned_workspace_ids = accounts.map(&:workspaces).flatten.pluck(:id)

    Workspace.where(id: member_workspace_ids + owned_workspace_ids)
  end

  def short_name
    email.split("@").first
  end

  def display_name
    name.present? ? name : short_name
  end

  private

  def primary_account
    accounts.first
  end

  # Move to the policy layer
  def account_owner?(account)
    account&.owner_id == id
  end

  # Move to the policy layer
  def can_access_account?(account)
    account_owner?(account)
  end

  # Move to the policy layer
  def can_access_workspace?(workspace)
    return false unless workspace
    can_access_account?(workspace.account)
  end

  # Move to the policy layer
  def accessible_workspaces
    workspaces.joins(:account).where(accounts: { owner_id: id })
  end
end
