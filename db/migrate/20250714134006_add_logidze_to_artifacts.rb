class AddLogidzeToArtifacts < ActiveRecord::Migration[8.0]
  def change
    add_column :artifacts, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_artifacts, on: :artifacts
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_artifacts" on "artifacts";
        SQL
      end
    end
  end
end
