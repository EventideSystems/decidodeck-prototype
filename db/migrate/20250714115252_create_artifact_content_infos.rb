class CreateArtifactContentInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :artifact_content_infos, id: :uuid do |t|
      t.references :owner, null: false, polymorphic: true, type: :uuid
      t.string :markdown
      t.timestamps
    end
  end
end
