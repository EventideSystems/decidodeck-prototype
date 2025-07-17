class Account < ApplicationRecord
  has_discard
  has_logidze

  has_many :workspaces, dependent: :destroy
  has_many :stakeholders, class_name: "Stakeholders::Base", dependent: :destroy
  belongs_to :owner, class_name: "User", foreign_key: :owner_id, inverse_of: :accounts

  def individuals
    stakeholders.where(type: "Stakeholders::Individual")
  end

  def organizations
    stakeholders.where(type: "Stakeholders::Organization")
  end
end
