
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
class Stakeholders::Individual < Stakeholders::Base
  # Validations specific to Individual
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :job_title, length: { maximum: 100 }, allow_blank: true

  # Scopes
  scope :by_name, ->(name) { where("CONCAT(first_name, ' ', last_name) ILIKE ?", "%#{name}%") }
  scope :by_job_title, ->(title) { where("job_title ILIKE ?", "%#{title}%") }

  # Callbacks
  before_save :set_name_from_first_and_last_name

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    full_name
  end

  def formal_name
    if job_title.present?
      "#{full_name}, #{job_title}"
    else
      full_name
    end
  end

  def age
    return nil unless birth_date.present?

    today = Date.current
    age = today.year - birth_date.year
    age -= 1 if today < birth_date + age.years
    age
  end

  def initials
    "#{first_name.first}#{last_name.first}".upcase
  end

  # Contact methods
  def professional_title
    job_title.presence || "Contact"
  end

  def vcard_name
    "#{last_name};#{first_name}"
  end

  private

  def set_name_from_subclass
    self.name = full_name if first_name.present? && last_name.present?
  end

  def set_name_from_first_and_last_name
    if first_name.present? || last_name.present?
      self.name = [ first_name, last_name ].compact.join(" ").strip
    end
  end
end
