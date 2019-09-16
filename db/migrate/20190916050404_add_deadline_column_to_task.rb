class AddDeadlineColumnToTask < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :string, null: false, default: "0000-00-00"
  end
end
