# == Schema Information
#
# Table name: accounts
#
#  id              :uuid             not null, primary key
#  description     :text
#  discarded_at    :datetime
#  log_data        :jsonb
#  max_users       :integer          default(3)
#  max_workspaces  :integer          default(1)
#  name            :citext           not null
#  plan            :string           default("free"), not null
#  plan_expires_at :datetime         default(2014-01-01 00:00:00.000000000 UTC +00:00), not null
#  status          :string           default("active"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :uuid             not null
#
# Indexes
#
#  index_accounts_on_discarded_at  (discarded_at)
#  index_accounts_on_name          (name) UNIQUE
#  index_accounts_on_owner_id      (owner_id)
#  index_accounts_on_plan          (plan)
#  index_accounts_on_status        (status)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#
require 'rails_helper'

RSpec.describe Account, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
