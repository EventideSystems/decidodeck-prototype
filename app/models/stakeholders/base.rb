# app/models/people/stakeholder.rb
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
class Stakeholders::Base < ApplicationRecord
  self.table_name = "stakeholders"

  has_discard
  has_logidze

  belongs_to :account, class_name: "Account"

  # Validations
  validates :name, presence: true, length: { minimum: 1, maximum: 200 }
  validates :status, inclusion: { in: %w[active inactive archived] }
  validates :stakeholder_type, inclusion: {
    in: %w[customer supplier partner investor employee regulator community other]
  }
  validates :influence_level, inclusion: { in: %w[low medium high critical] }
  validates :interest_level, inclusion: { in: %w[low medium high critical] }
  validates :priority_score, inclusion: { in: 1..100 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true

  # Scopes
  scope :active, -> { where(status: "active") }
  scope :by_stakeholder_type, ->(type) { where(stakeholder_type: type) }
  scope :high_influence, -> { where(influence_level: [ "high", "critical" ]) }
  scope :high_interest, -> { where(interest_level: [ "high", "critical" ]) }
  scope :high_priority, -> { where("priority_score >= ?", 75) }
  scope :by_influence, ->(level) { where(influence_level: level) }
  scope :by_interest, ->(level) { where(interest_level: level) }

  # Callbacks
  before_validation :set_name_from_subclass, if: -> { name.blank? }

  # Class methods
  def self.stakeholder_types
    %w[customer supplier partner investor employee regulator community other]
  end

  def self.influence_levels
    %w[low medium high critical]
  end

  def self.interest_levels
    %w[low medium high critical]
  end

  # Instance methods
  def active?
    status == "active"
  end

  def high_influence?
    influence_level.in?(%w[high critical])
  end

  def high_interest?
    interest_level.in?(%w[high critical])
  end

  def stakeholder_matrix_position
    "#{influence_level.capitalize} Influence, #{interest_level.capitalize} Interest"
  end

  def display_name
    name
  end

  def contact_info
    [ email, phone ].compact.join(" | ")
  end

  # Calculate stakeholder engagement strategy based on influence/interest matrix
  def engagement_strategy
    case [ influence_level, interest_level ]
    when [ "high", "high" ], [ "critical", "high" ], [ "high", "critical" ], [ "critical", "critical" ]
      "Manage Closely"
    when [ "high", "low" ], [ "critical", "low" ], [ "high", "medium" ], [ "critical", "medium" ]
      "Keep Satisfied"
    when [ "low", "high" ], [ "medium", "high" ], [ "low", "critical" ], [ "medium", "critical" ]
      "Keep Informed"
    else
      "Monitor"
    end
  end

  # Tag management
  def add_tag(tag)
    self.tags = (tags + [ tag.to_s ]).uniq
    save
  end

  def remove_tag(tag)
    self.tags = tags - [ tag.to_s ]
    save
  end

  def has_tag?(tag)
    tags.include?(tag.to_s)
  end

  private

  def set_name_from_subclass
    # Override in subclasses to set appropriate name
  end
end
