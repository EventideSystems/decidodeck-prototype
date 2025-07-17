class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.has_discard
    include Discard::Model
  end
end
