class CreateUserInfos < ActiveRecord::Migration[8.0]
  def change
    create_table :user_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :father_name
      t.string :national_id
      t.date :dob
      t.integer :gender
      t.integer :grade
      t.string :phone, limit: 11
      t.text :address
      t.string :personal_number, limit: 11
      t.string :company_number, limit: 11
      t.string :employee_code

      t.timestamps
    end
  end
end
