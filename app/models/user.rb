class User < ApplicationRecord
  attr_accessor :current_step
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
   validates :email, :password, :name, presence: true

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles
  accepts_nested_attributes_for :user_roles
  belongs_to :department, optional: true
  has_one :user_info, dependent: :destroy
  accepts_nested_attributes_for :user_info
  has_many :job_employments, dependent: :destroy
  accepts_nested_attributes_for :job_employments
  has_many :asset_details, dependent: :destroy
  accepts_nested_attributes_for :asset_details, allow_destroy: true
  has_many :bank_details, dependent: :destroy
  accepts_nested_attributes_for :bank_details, allow_destroy: true

  with_options if: -> { current_step == "basic_info" } do
    validates :name, :email, :password, presence: true
  end

  with_options if: -> { current_step == "user_info" } do
    validates_associated :user_info
  end

  with_options if: -> { current_step == "job_employments" } do
    validates_associated :job_employments
  end

  with_options if: -> { current_step == "asset_details" } do
    validates_associated :asset_details
  end

  with_options if: -> { current_step == "bank_details" } do
    validates_associated :bank_details
  end

    def active_for_authentication? # Overriding it allows you to add your own custom condition, like checking if the user is active
     super && active?
    end
end
