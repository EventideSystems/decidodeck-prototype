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
require 'rails_helper'

RSpec.describe Workspace, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
