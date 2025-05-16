# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!

  # Admin user list
  def index
    @users = User.all
  end

  # Admin: new user form
  def new_user
    @user = User.new
    @user.build_user_info  # You need to make sure this is set up to build the associated user_info.
    @user.job_employments.build  # <-- use `.build`, because it's a has_many
    @user.asset_details.build   # <-- use `.build`, because it's a has_many
    @user.bank_details.build    # <-- use `.build`, because it's a has_many
  end

  # Admin: create user action
  def create_user
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_list_path, notice: "User created successfully."
    else
      render :new_user
    end
  end

  # Admin: edit user form
  def edit
    @user = User.find(params[:id])
    @user.build_user_info if @user.user_info.blank?
    @user.bank_details.build if @user.bank_details.blank?
    @user.job_employments.build if @user.job_employments.blank?
    @user.asset_details.build if @user.asset_details.blank?
  end

  # Admin: update user action
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_list_path, notice: "User updated successfully."
    else
      render :edit
    end
  end

  # Admin: delete user
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_user_list_path, notice: "User deleted successfully."
  end

  # Regular Devise user profile show
  def show
    @user = current_user
  end

  private

  # def authenticate_admin!
  #   # Your admin authentication logic, e.g.:
  #   redirect_to root_path, alert: "Not authorized" unless current_user&.admin?
  # end

 def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :department_id, :name, :active, role_ids: [],
    user_info_attributes: [ :id, :father_name, :gender, :grade, :national_id, :dob, :phone, :personal_number, :company_number, :employee_code, :address ],
    job_employments_attributes: [ :employment_type, :job_title, :hire_date, :work_location, :manager_name, :job_status, :blood_group, :employee_service ],
    asset_details_attributes: [ :id, :name, :model, :brand, :serial_number, :assigned_date, :returned_date, :status, :notes ],
    bank_details_attributes: [ :id, :salary_structure, :payment_method, :bank_name, :bank_account_number, :payroll_group_id, :_destroy ],
    )
  end
end
