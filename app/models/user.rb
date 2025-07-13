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

  attr_accessor :current_sign_in_ip, :last_sign_in_ip

  def active_for_authentication?
    super && active? && !discarded?
  end

  def primary_account
    accounts.first
  end

  def account_owner?(account)
    account&.owner_id == id
  end

  def can_access_account?(account)
    account_owner?(account)
  end

  def can_access_workspace?(workspace)
    return false unless workspace
    can_access_account?(workspace.account)
  end

  def accessible_workspaces
    workspaces.joins(:account).where(accounts: { owner_id: id })
  end
end
