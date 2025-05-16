class AssetDetail < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :serial_number, presence: true
  validates :assigned_date, presence: true
  validates :returned_date, presence: true
end
