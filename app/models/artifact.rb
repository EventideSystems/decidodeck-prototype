class Artifact < ApplicationRecord
  has_discard
  has_logidze

  belongs_to :workspace, optional: false
  belongs_to :content, polymorphic: true, optional: false

  # Clean up tags before saving
  before_save :clean_tags

  private

  def clean_tags
    # Remove empty strings and nil values from tags array
    self.tags = tags.reject(&:blank?) if tags.present?
  end
end
