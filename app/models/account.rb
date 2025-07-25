class Account < ApplicationRecord
  has_discard
  has_logidze

  belongs_to :owner, class_name: "User", foreign_key: :owner_id, inverse_of: :accounts

  has_many :workspaces, dependent: :destroy
  has_many :stakeholders, class_name: "Stakeholders::Base", dependent: :destroy
  has_many :account_members, dependent: :destroy
  has_many :members, through: :account_members, source: :user, inverse_of: :accounts

  def stakeholders_individuals
    stakeholders.where(type: "Stakeholders::Individual")
  end

  def stakeholders_organizations
    stakeholders.where(type: "Stakeholders::Organization")
  end

  def display_name
    name
  end
end
