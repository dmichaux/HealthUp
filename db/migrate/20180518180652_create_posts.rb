class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :author_id
      t.references :cohort, foreign_key: true

      t.timestamps
    end

    add_foreign_key :posts, :users, column: :author_id
  end
end
