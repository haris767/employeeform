class CreateBankDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :bank_details do |t|
      t.references :user, null: false, foreign_key: true
      t.string :salary_structure
      t.string :payment_method
      t.string :bank_name
      t.string :bank_account_number

      t.timestamps
    end
  end
end
