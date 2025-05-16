class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :doc_type
      t.references :employee, null: false, foreign_key: true # employee ki id ab foreign key hai document main

      t.timestamps
    end
  end
end
