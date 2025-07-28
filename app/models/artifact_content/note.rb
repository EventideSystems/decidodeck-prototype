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
class ArtifactContent::Note < ApplicationRecord
  self.table_name = "artifact_content_notes"

  has_discard
  has_logidze

  belongs_to :owner, polymorphic: true
  has_one :artifact, as: :content, dependent: :destroy

  validates :markdown, presence: true

  def display_name
    title.presence || markdown.lines.first.truncate(50)
  end
end
