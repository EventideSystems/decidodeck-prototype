# == Schema Information
#
# Table name: people
#
#  id                :uuid
#  address           :text
#  birth_date        :date
#  description       :text
#  email             :citext
#  employee_count    :integer
#  first_name        :string(50)
#  founded_date      :date
#  industry          :string(100)
#  influence_level   :string
#  interest_level    :string
#  job_title         :string(100)
#  last_name         :string(50)
#  legal_name        :string(200)
#  name              :string(200)
#  organization_type :string(50)
#  person_sub_type   :text
#  person_type       :text
#  phone             :string(20)
#  priority_score    :integer
#  stakeholder_type  :string(50)
#  status            :string
#  website           :string(100)
#  account_id        :uuid
#
class Person < ApplicationRecord
  belongs_to :account, class_name: "Account"
end
