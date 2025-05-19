class JobEmployment < ApplicationRecord
  belongs_to :user
  with_options if: -> { user.current_step == "job_employment" } do
    validates :job_title, presence: true
    validates :employment_type, presence: true
    validates :hire_date, presence: true
    validates :manager_name, presence: true
  end
end
