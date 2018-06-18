class CreateUserGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :user_goals do |t|
      t.string :body
      t.integer :user_id

      t.timestamps
    end

    add_foreign_key :user_goals, :users
  end
end
