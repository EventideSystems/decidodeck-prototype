class CreateAccountMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :account_members, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end

    add_index :account_members, [ :account_id, :user_id ], unique: true
  end
end
