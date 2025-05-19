class UserInfo < ApplicationRecord
  belongs_to :user
  enum :gender, { male: 1, female: 2, other: 3 }
  enum :grade, { a: 1, b: 2, c: 3, d: 4 }

  # Validations (optional, but recommended)
  with_options if: -> { user.current_step == "user_info" } do
    validates :father_name, presence: true
    validates :dob, presence: true
    validates :phone, length: { is: 11 }
    validates :personal_number, length: { is: 11 }
    validates :company_number, length: { is: 11 }
    validates :national_id, length: { is: 13 }
    validate :dob_cannot_be_in_the_future
  end
  before_create :generate_employee_code

  private
  def generate_employee_code
    self.employee_code = "EMP#{self.user_id}"  # Add user_id here  => e.g., EMP1
  end

  def dob_cannot_be_in_the_future
  errors.add(:dob, "can't be in the future") if dob.present? && dob > Date.today
  end
end
