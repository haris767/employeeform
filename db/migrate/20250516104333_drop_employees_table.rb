class DropEmployeesTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :employees
  end
end
