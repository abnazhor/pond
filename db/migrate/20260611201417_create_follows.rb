class CreateFollows < ActiveRecord::Migration[8.1]
  def change
    create_table :follows do |t|
      t.references :actor, null: false, foreign_key: { to_table: :users }
      t.references :target, polymorphic: true, null: false

      t.timestamps
    end
  end
end
