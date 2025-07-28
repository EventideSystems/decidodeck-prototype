# == Schema Information
#
# Table name: workspaces
#
#  id             :uuid             not null, primary key
#  description    :text
#  discarded_at   :datetime
#  log_data       :jsonb
#  name           :citext           not null
#  status         :string           default("active"), not null
#  workspace_type :string           default("project"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :uuid             not null
#
# Indexes
#
#  index_workspaces_on_account_and_name  (account_id,name) UNIQUE
#  index_workspaces_on_account_id        (account_id)
#  index_workspaces_on_discarded_at      (discarded_at)
#  index_workspaces_on_status            (status)
#  index_workspaces_on_workspace_type    (workspace_type)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
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
