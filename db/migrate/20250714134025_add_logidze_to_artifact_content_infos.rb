class AddLogidzeToArtifactContentInfos < ActiveRecord::Migration[8.0]
  def change
    add_column :artifact_content_infos, :log_data, :jsonb

    reversible do |dir|
      dir.up do
        create_trigger :logidze_on_artifact_content_infos, on: :artifact_content_infos
      end

      dir.down do
        execute <<~SQL
          DROP TRIGGER IF EXISTS "logidze_on_artifact_content_infos" on "artifact_content_infos";
        SQL
      end
    end
  end
end
