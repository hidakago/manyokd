class AddColumnToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :admin_allowed, :boolean, default: false, null: false
  end
end
