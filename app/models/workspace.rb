class Workspace < ApplicationRecord
  has_discard
  has_logidze

  belongs_to :account
  has_many :artifacts, dependent: :destroy

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
