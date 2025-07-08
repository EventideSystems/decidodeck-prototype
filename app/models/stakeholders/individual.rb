
class Stakeholders::Individual < Stakeholders::Base
  # Validations specific to Individual
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :job_title, length: { maximum: 100 }, allow_blank: true

  # Scopes
  scope :by_name, ->(name) { where("CONCAT(first_name, ' ', last_name) ILIKE ?", "%#{name}%") }
  scope :by_job_title, ->(title) { where("job_title ILIKE ?", "%#{title}%") }

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
end
