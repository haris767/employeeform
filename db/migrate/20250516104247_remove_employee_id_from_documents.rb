class RemoveEmployeeIdFromDocuments < ActiveRecord::Migration[8.0]
  def change
    remove_reference :documents, :employee, null: false, foreign_key: true
  end
end
