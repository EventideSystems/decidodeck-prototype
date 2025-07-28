# == Schema Information
#
# Table name: artifact_content_notes
#
#  id           :uuid             not null, primary key
#  discarded_at :datetime
#  log_data     :jsonb
#  markdown     :string
#  note_type    :string           default("text"), not null
#  owner_type   :string           not null
#  title        :string           default(""), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  owner_id     :uuid             not null
#
# Indexes
#
#  index_artifact_content_notes_on_owner  (owner_type,owner_id)
#
require 'rails_helper'

RSpec.describe ArtifactContent::Note, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
