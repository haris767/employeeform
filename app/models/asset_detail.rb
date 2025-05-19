class AssetDetail < ApplicationRecord
  belongs_to :user
  with_options if: -> { user.current_step == "asset_detail" } do
    validates :name, presence: true
    validates :serial_number, presence: true
    validates :assigned_date, presence: true
    validates :returned_date, presence: true
  end
end
