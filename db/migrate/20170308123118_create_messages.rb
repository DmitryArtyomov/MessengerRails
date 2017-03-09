class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :text, null: false
      t.boolean :read, default: false
      t.timestamps
    end

    add_reference :messages, :sender, references: :users, null: false
    add_foreign_key :messages, :users, column: :sender_id

    add_reference :messages, :receiver, references: :users, null: false
    add_foreign_key :messages, :users, column: :receiver_id

    add_index :messages, [:sender_id, :receiver_id]
  end
end
