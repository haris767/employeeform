class BankDetail < ApplicationRecord
  belongs_to :user


  validates :salary_structure, presence: true
  validates :payment_method, presence: true
  validates :bank_name, presence: true
  validates :bank_account_number, presence: true
end
