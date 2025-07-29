class CreateArtifacts < ActiveRecord::Migration[8.0]
  def change
    create_table :artifacts, id: :uuid do |t|
      ## Core artifact information
      t.integer :position, null: false, default: 0
      t.string :tags, array: true, default: []

      ## Foreign keys as UUIDs
      t.references :workspace, null: false, foreign_key: true, type: :uuid
      t.references :content, polymorphic: true, null: false, type: :uuid

      ## Discardable
      t.datetime :discarded_at, null: true

      t.timestamps
    end
  end
end
