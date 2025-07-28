# app/models/people/organization.rb
# == Schema Information
#
# Table name: stakeholders
#
#  id                :uuid             not null, primary key
#  address           :text
#  birth_date        :date
#  description       :text
#  discarded_at      :datetime
#  email             :citext
#  employee_count    :integer
#  first_name        :string(50)
#  founded_date      :date
#  industry          :string(100)
#  influence_level   :string           default("medium"), not null
#  interest_level    :string           default("medium"), not null
#  job_title         :string(100)
#  last_name         :string(50)
#  legal_name        :string(200)
#  log_data          :jsonb
#  name              :string(200)      not null
#  organization_type :string(50)
#  phone             :string(20)
#  priority_score    :integer          default(50)
#  stakeholder_type  :string(50)
#  status            :string           default("active"), not null
#  type              :string(50)       not null
#  website           :string(100)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :uuid             not null
#
# Indexes
#
#  index_active_stakeholders_on_account                   (account_id) WHERE ((status)::text = 'active'::text)
#  index_stakeholders_on_account_id                       (account_id)
#  index_stakeholders_on_account_id_and_name              (account_id,name)
#  index_stakeholders_on_account_id_and_stakeholder_type  (account_id,stakeholder_type)
#  index_stakeholders_on_account_id_and_type              (account_id,type)
#  index_stakeholders_on_email                            (email)
#  index_stakeholders_on_first_name_and_last_name         (first_name,last_name) WHERE ((type)::text = 'People::Person'::text)
#  index_stakeholders_on_influence_level                  (influence_level)
#  index_stakeholders_on_interest_level                   (interest_level)
#  index_stakeholders_on_organization_type                (organization_type) WHERE ((type)::text = 'People::Organization'::text)
#  index_stakeholders_on_priority_score                   (priority_score)
#  index_stakeholders_on_stakeholder_type                 (stakeholder_type)
#  index_stakeholders_on_status                           (status)
#  index_stakeholders_on_type                             (type)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
class Stakeholders::Organization < Stakeholders::Base
  # Validations specific to Organization
  validates :legal_name, presence: true, length: { maximum: 200 }
  validates :organization_type, inclusion: {
    in: %w[corporation nonprofit government partnership llc sole_proprietorship other]
  }, allow_blank: true
  validates :industry, length: { maximum: 100 }, allow_blank: true
  validates :employee_count, numericality: { greater_than: 0 }, allow_blank: true

  # Scopes
  scope :by_type, ->(type) { where(organization_type: type) }
  scope :by_industry, ->(industry) { where("industry ILIKE ?", "%#{industry}%") }
  scope :by_size, ->(size) {
    case size.to_s.downcase
    when "startup", "small"
      where("employee_count <= ?", 50)
    when "medium"
      where("employee_count BETWEEN ? AND ?", 51, 250)
    when "large"
      where("employee_count BETWEEN ? AND ?", 251, 1000)
    when "enterprise"
      where("employee_count > ?", 1000)
    end
  }

  # Class methods
  def self.organization_types
    %w[corporation nonprofit government partnership llc sole_proprietorship other]
  end

  # Instance methods
  def display_name
    name.presence || legal_name
  end

  def formal_name
    legal_name
  end

  def organization_size
    return "Unknown" unless employee_count.present?

    case employee_count
    when 1..10
      "Startup"
    when 11..50
      "Small"
    when 51..250
      "Medium"
    when 251..1000
      "Large"
    else
      "Enterprise"
    end
  end

  def age_in_years
    return nil unless founded_date.present?

    today = Date.current
    age = today.year - founded_date.year
    age -= 1 if today < founded_date + age.years
    age
  end

  def is_corporation?
    organization_type == "corporation"
  end

  def is_nonprofit?
    organization_type == "nonprofit"
  end

  def is_government?
    organization_type == "government"
  end

  # Business information
  def business_summary
    parts = []
    parts << organization_type.humanize if organization_type.present?
    parts << "in #{industry}" if industry.present?
    parts << "with #{employee_count} employees" if employee_count.present?
    parts << "founded in #{founded_date.year}" if founded_date.present?

    parts.join(", ")
  end

  def contact_person_title
    case organization_type
    when "corporation", "llc"
      "Business Contact"
    when "nonprofit"
      "Organization Contact"
    when "government"
      "Government Contact"
    else
      "Contact"
    end
  end

  private

  def set_name_from_subclass
    self.name = legal_name if legal_name.present?
  end
end
