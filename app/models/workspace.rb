class Workspace < ApplicationRecord
  include Discard::Model
  has_logidze

  belongs_to :account
end
