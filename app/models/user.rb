class User < ApplicationRecord
  include Discard::Model
  has_logidze

  enum :status, { active: "active",  suspended: "suspended", archived: "archived" }

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :trackable

  has_many :accounts, dependent: :destroy, inverse_of: :owner
  has_many :workspaces, through: :accounts

  attr_accessor :current_sign_in_ip, :last_sign_in_ip

  def active_for_authentication?
    super && active? && !discarded?
  end
end
