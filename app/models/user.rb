class User < ApplicationRecord
  include Discard::Model
  has_logidze

  enum :status, { active: "active",  suspended: "suspended", archived: "archived" }

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_many :accounts, dependent: :destroy, inverse_of: :owner, foreign_key: :owner_id
  has_many :workspaces, through: :accounts

  # Using virtual attributes to disable tracking of sign-in IPs (for privacy reasons)
  # If you need to track IPs, you can remove these lines and use Devise's default behavior.
  # However, ensure that you comply with privacy regulations regarding IP tracking. You will also need to
  # add `current_sign_in_ip` and `last_sign_in_ip` to the database schema if you want to track them.
  attr_accessor :current_sign_in_ip, :last_sign_in_ip

  private

  def active_for_authentication?
    super && active? && !discarded?
  end

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
