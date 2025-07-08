class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts, id: :uuid do |t|
      ## Core account information
      t.citext :name, null: false
      t.text :description

      ## Account status
      t.string :status, null: false, default: 'active' # active, archived, suspended

      ## Subscription and billing
      t.string :plan, null: false, default: 'trial' # trial, free, pro, enterprise
      t.datetime :plan_expires_at, null: false, default: "now() + interval '14 day';"

      ## Usage limits and quotas
      t.integer :max_users, default: 3
      t.integer :max_workspaces, default: 1

      ## Discardable
      t.datetime :discarded_at, null: true

      ## Foreign keys as UUIDs
      t.references :owner, null: false, foreign_key: { to_table: :users }, type: :uuid

      t.timestamps
    end

    # Indexes
    add_index :accounts, :name, unique: true
    add_index :accounts, :status
    add_index :accounts, :plan
    add_index :accounts, :discarded_at

    # Check constraints
    add_check_constraint :accounts, "status IN ('active', 'suspended', 'archived')", name: "accounts_valid_status"
    add_check_constraint :accounts, "plan IN ('trial', 'free', 'pro', 'enterprise')", name: "accounts_valid_plan"
  end
end
