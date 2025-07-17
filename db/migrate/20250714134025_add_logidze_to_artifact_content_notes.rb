class AddLogidzeToArtifactContentNotes < ActiveRecord::Migration[8.0]
  def change
    add_column :artifact_content_notes, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_artifact_content_notes, on: :artifact_content_notes
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_artifact_content_notes" on "artifact_content_notes";
        SQL
      end
    end
  end
end
