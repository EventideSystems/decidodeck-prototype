# == Schema Information
#
# Table name: artifacts
#
#  id           :uuid             not null, primary key
#  content_type :string           not null
#  discarded_at :datetime
#  log_data     :jsonb
#  position     :integer          default(0), not null
#  tags         :string           default([]), is an Array
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content_id   :uuid             not null
#  workspace_id :uuid             not null
#
# Indexes
#
#  index_artifacts_on_content       (content_type,content_id)
#  index_artifacts_on_workspace_id  (workspace_id)
#
# Foreign Keys
#
#  fk_rails_...  (workspace_id => workspaces.id)
#
FactoryBot.define do
  factory :artifact do
  end
end
