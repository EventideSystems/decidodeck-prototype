# app/models/people/organization.rb
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
