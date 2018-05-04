class AddOpenedToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :opened, :boolean, default: false
  end
end
