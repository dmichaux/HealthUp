class CreateCohortGoals < ActiveRecord::Migration[5.1]
  def change
    create_table :cohort_goals do |t|
      t.string :body
      t.integer :cohort_id

      t.timestamps
    end

    add_foreign_key :cohort_goals, :cohorts
  end
end
