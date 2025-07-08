class AddLogidzeToStakeholders < ActiveRecord::Migration[8.0]
  def change
    add_column :stakeholders, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_stakeholders, on: :stakeholders
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_stakeholders" on "stakeholders";
        SQL
      end
    end
  end
end
