class ArtifactContent::Info < ApplicationRecord
  self.table_name = "artifact_content_infos"
  has_logidze

  belongs_to :owner, polymorphic: true
  has_many :artifacts, as: :content, dependent: :destroy

  validates :markdown, presence: true

  def display_name
    markdown.truncate(50)
  end
end
