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
class Person < ApplicationRecord
  belongs_to :account, class_name: "Account"
end
