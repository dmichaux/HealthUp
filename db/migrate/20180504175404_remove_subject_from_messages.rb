class RemoveSubjectFromMessages < ActiveRecord::Migration[5.1]
  def change
  	remove_column :messages, :subject, :string
  end
end
