class Artifact < ApplicationRecord
  has_discard
  has_logidze

  belongs_to :workspace, optional: false
  belongs_to :content, polymorphic: true, optional: false
end
