class CreateOutsideMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :outside_messages do |t|
      t.string :name
      t.string :email
      t.text :body
      t.boolean :opened, default: false
      t.integer :to_admin_id

      t.timestamps
    end
  end
end
