class Workspace < ApplicationRecord
  include Discard::Model
  has_logidze

  belongs_to :account

  validates :name, presence: true
  validates :workspace_type, inclusion: {
    in: %w[project program department initiative template]
  }
  validates :status, inclusion: {
    in: %w[active archived suspended]
  }

  scope :active, -> { where(status: "active") }
  scope :by_type, ->(type) { where(workspace_type: type) }

  def active?
    status == "active"
  end

  def display_name
    name
  end
end
