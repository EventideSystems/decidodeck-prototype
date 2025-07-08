class CreateWorkspaces < ActiveRecord::Migration[8.0]
  def change
    create_table :workspaces, id: :uuid do |t|
      # Core workspace information
      t.citext :citext, null: false
      t.text :description

      ## Workspace type and status
      t.string :workspace_type, null: false, default: 'project' # project, program, department, initiative, template
      t.string :status, null: false, default: 'active' # active, archived, suspended

      ## Discardable
      t.datetime :discarded_at, null: true

      ## Foreign keys as UUIDs
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    # Indexes
    add_index :workspaces, [ :account_id, :name ], unique: true, name: 'index_workspaces_on_account_and_name'
    add_index :workspaces, :workspace_type
    add_index :workspaces, :status
    add_index :workspaces, :discarded_at

    # Check constraints
    add_check_constraint :workspaces, "workspace_type IN ('project', 'program', 'department', 'initiative', 'template')", name: "workspaces_valid_type"
    add_check_constraint :workspaces, "status IN ('active', 'archived', 'suspended')", name: "workspaces_valid_status"
  end
end
