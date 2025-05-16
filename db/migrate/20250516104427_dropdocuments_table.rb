class DropdocumentsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :documents
  end
end
