# app/models/people/stakeholder.rb
class Stakeholders::Base < ApplicationRecord
  self.table_name = "stakeholders"

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
