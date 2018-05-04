class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer :from_user_id
      t.integer :to_user_id
      t.string :subject
      t.text :body

      t.timestamps
    end

    add_foreign_key :messages, :users, column: :from_user_id
    add_foreign_key :messages, :users, column: :to_user_id
    add_index :messages, [:from_user_id, :to_user_id]
  end
end
