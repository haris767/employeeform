class JobEmployment < ApplicationRecord
  belongs_to :user

  validates :job_title, presence: true
  validates :employment_type, presence: true
  validates :hire_date, presence: true
  validates :manager_name, presence: true

end
