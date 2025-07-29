class CreateArtifactContentNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :artifact_content_notes, id: :uuid do |t|
      t.string :title, null: false, default: ""
      t.string :markdown
      t.string :note_type, null: false, default: "text" # text, checklist, code

      ## Foreign keys as UUIDs
      t.references :owner, null: false, polymorphic: true, type: :uuid

      ## Discardable
      t.datetime :discarded_at, null: true

      t.timestamps
    end
  end
end
