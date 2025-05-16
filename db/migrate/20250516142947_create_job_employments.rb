class CreateJobEmployments < ActiveRecord::Migration[8.0]
  def change
    create_table :job_employments do |t|
      t.references :user, null: false, foreign_key: true
      t.string :job_title
      t.string :employment_type
      t.date :hire_date
      t.string :work_location
      t.string :manager_name
      t.string :job_status
      t.string :blood_group
      t.string :employee_service

      t.timestamps
    end
  end
end
