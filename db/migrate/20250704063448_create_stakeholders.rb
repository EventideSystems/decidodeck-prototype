class CreateStakeholders < ActiveRecord::Migration[8.0]
  def change
    create_table :stakeholders, id: :uuid do |t|
      ## STI type column
      t.string :type, null: false, limit: 50

      ## Core party information
      t.string :name, null: false, limit: 200
      t.text :description
      t.string :status, null: false, default: 'active' # active, inactive, archived
      t.text :notes

      ## Contact information
      t.citext :email
      t.string :phone, limit: 20
      t.text :address
      t.string :website, limit: 100

      ## Person-specific fields
      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.string :job_title, limit: 100
      t.date :birth_date

      ## Organization-specific fields
      t.string :legal_name, limit: 200
      t.string :organization_type, limit: 50 # corporation, nonprofit, government, partnership
      t.string :industry, limit: 100
      t.integer :employee_count
      t.date :founded_date

      ## Stakeholder relationship fields
      t.string :stakeholder_type, limit: 50 # customer, supplier, partner, investor, employee, regulator
      t.string :influence_level, null: false, default: 'medium' # low, medium, high, critical
      t.string :interest_level, null: false, default: 'medium' # low, medium, high, critical
      t.integer :priority_score, default: 50 # 1-100 scale

      ## Discardable
      t.datetime :discarded_at, null: true

      ## Foreign keys as UUIDs
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    # Indexes for performance
    add_index :stakeholders, [ :account_id, :type ]
    add_index :stakeholders, [ :account_id, :name ]
    add_index :stakeholders, [ :account_id, :stakeholder_type ]
    add_index :stakeholders, :type
    add_index :stakeholders, :status
    add_index :stakeholders, :email
    add_index :stakeholders, :stakeholder_type
    add_index :stakeholders, :influence_level
    add_index :stakeholders, :interest_level
    add_index :stakeholders, :priority_score
    add_index :stakeholders, :organization_type, where: "type = 'People::Organization'"
    add_index :stakeholders, [ :first_name, :last_name ], where: "type = 'People::Person'"

    # Partial indexes for active stakeholders
    add_index :stakeholders, :account_id, where: "status = 'active'", name: 'index_active_stakeholders_on_account'

    # Check constraints
    add_check_constraint :stakeholders, "char_length(name) >= 1", name: "stakeholders_name_length"
    add_check_constraint :stakeholders, "type IN ('Stakeholders::Individual', 'Stakeholders::Organization')", name: "stakeholders_valid_type"
    add_check_constraint :stakeholders, "status IN ('active', 'inactive', 'archived')", name: "stakeholders_valid_status"
    add_check_constraint :stakeholders, "stakeholder_type IN ('customer', 'supplier', 'partner', 'investor', 'employee', 'regulator', 'community', 'other')", name: "stakeholders_valid_stakeholder_type"
    add_check_constraint :stakeholders, "influence_level IN ('low', 'medium', 'high', 'critical')", name: "stakeholders_valid_influence_level"
    add_check_constraint :stakeholders, "interest_level IN ('low', 'medium', 'high', 'critical')", name: "stakeholders_valid_interest_level"
    add_check_constraint :stakeholders, "priority_score >= 1 AND priority_score <= 100", name: "stakeholders_valid_priority_score"

    # Type-specific constraints
    add_check_constraint :stakeholders,
      "(type != 'Stakeholders::Individual') OR (first_name IS NOT NULL AND last_name IS NOT NULL)",
      name: "person_requires_names"
    add_check_constraint :stakeholders,
      "(type != 'Stakeholders::Organization') OR (legal_name IS NOT NULL)",
      name: "organization_requires_legal_name"
  end
end
