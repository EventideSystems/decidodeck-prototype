# == Schema Information
#
# Table name: people
#
#  id                   :uuid
#  email                :citext
#  influence_level      :string
#  interest_level       :string
#  linked_resource_type :string
#  name                 :string
#  person_sub_type      :text
#  person_type          :text
#  status               :string
#  created_at           :datetime
#  updated_at           :datetime
#  account_id           :uuid
#  linked_resource_id   :uuid
#
require 'rails_helper'

RSpec.describe Person, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
