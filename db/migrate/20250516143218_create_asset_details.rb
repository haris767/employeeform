class CreateAssetDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :asset_details do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :brand
      t.string :model
      t.string :serial_number
      t.date :assigned_date
      t.date :returned_date
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
