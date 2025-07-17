class ArtifactContent::Note < ApplicationRecord
  self.table_name = "artifact_content_notes"

  has_discard
  has_logidze

  belongs_to :owner, polymorphic: true
  has_one :artifact, as: :content, dependent: :destroy

  validates :markdown, presence: true

  def display_name
    title.presence || markdown.truncate(50)
  end
end
