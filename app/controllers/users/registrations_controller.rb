# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!
  STEPS = %w[basic_info user_info job_employment asset_details bank_details]
  # Admin user list
  def index
    @users = User.all
  end

 
   # Admin: new user form
  def new_user
    @user = User.new
    @user.build_user_info
    @user.job_employments.build
    @user.asset_details.build
    @user.bank_details.build
    @step = STEPS.first
    # 👇 This is the missing line
    next_step_name = next_step(@step)

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "user_form",
          partial: "users/registrations/form_step",
          locals: { user: @user, step: next_step_name }
        )
      end
    end
  end


  def create_user
    @step = params[:step] || "basic_info"
    @user = User.new(user_params)

    # Set the current step for validations
    @user.current_step = @step

    # Build nested attributes for the next step if not present
    @user.build_user_info if @user.user_info.nil?
    @user.job_employments.build if @user.job_employments.blank?
    @user.asset_details.build if @user.asset_details.blank?
    @user.bank_details.build if @user.bank_details.blank?

    unless step_allowed?(@step)
      first_incomplete = first_incomplete_step
      return redirect_to new_user_by_admin_path(step: first_incomplete), alert: "Please complete previous steps first."
    end

    if validate_step(@user, @step)
      mark_step_completed(@step) # Mark this step as completed
      next_step_name = next_step(@step)

      if next_step_name
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "user_form",
              partial: "users/registrations/form_step",
              locals: { user: @user, step: next_step_name }
            )
          end
          format.html { redirect_to new_user_path(step: next_step_name) }
        end
      else
        # Provide a default password if none is given
        if @user.password.blank?
          @user.password = Devise.friendly_token[0, 20]
          @user.skip_password_validation = true
        end

        @user.email = "temp_#{SecureRandom.hex(4)}@example.com" if @user.email.blank?
        @user.name = "Unnamed User" if @user.name.blank?

        if @user.save
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace(
                "user_form",
                 partial:"users/registrations/success", # <- ✅ create this partial
                locals: { user: @user }
              )
            end
            format.html { redirect_to admin_user_list_path, notice: "User created successfully" }
          end
        else
          # Fallback (shouldn't happen here, but safety net)
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: turbo_stream.replace(
                "user_form",
                partial: "users/registrations/form_step",
                locals: { user: @user, step: @step }
              )
            end
            format.html { render :new_user }
          end
        end
      end
    end
  end



  

  

  # def create_user
  #   @step = params[:step] || "basic_info"
  #   @user = User.new(user_params)

  #   # Set the current step for validations
  #   @user.current_step = @step

  #   # Build nested attributes for the next step if not present
  #   @user.build_user_info if @user.user_info.nil?
  #   @user.job_employments.build if @user.job_employments.blank?
  #   @user.asset_details.build if @user.asset_details.blank?
  #   @user.bank_details.build if @user.bank_details.blank?

  #   unless step_allowed?(@step)
  #     first_incomplete = first_incomplete_step
  #     return redirect_to new_user_by_admin_path(step: first_incomplete), alert: "Please complete previous steps first."
  #   end

  #   if validate_step(@user, @step)
  #     mark_step_completed(@step) # Mark this step as completed
  #     next_step_name = next_step(@step)

  #     if next_step_name
  #       respond_to do |format|
  #         format.turbo_stream do
  #           render turbo_stream: turbo_stream.replace(
  #             "user_form",
  #             partial: "users/registrations/form_step",
  #             locals: { user: @user, step: next_step_name }
  #           )
  #         end
  #         format.html { redirect_to new_user_path(step: next_step_name) }
  #       end
  #     else
        
  #       @user.save!
  #       redirect_to admin_user_list_path, notice: "User created successfully"
  #     end
  #   else
  #     respond_to do |format|
  #       format.turbo_stream do
  #         render turbo_stream: turbo_stream.replace(
  #           "user_form",
  #           partial: "users/registrations/form_step",
  #           locals: { user: @user, step: @step }  # keep current step on failure
  #         )
  #       end
  #       format.html { render :new_user }
  #     end
  #   end

  #   Rails.logger.debug "Step: #{@step}, Valid?: #{@user.errors.blank?}"
  # end


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
  
  def step_allowed?(step)
    # Check if all previous steps before `step` are completed
    steps = %w[basic_info user_info job_employment asset_details bank_details]
    current_index = steps.index(step)
    return false unless current_index

    # All steps before current_index must be marked completed
    completed = session[:completed_steps] || []
    steps[0...current_index].all? { |s| completed.include?(s) }
  end

  def mark_step_completed(step)
    #mark that this step is completed
    session[:completed_steps] ||= []
    session[:completed_steps] << step unless session[:completed_steps].include?(step)
  end

  def first_incomplete_step
    #if any incomplete step so user can't navigate next form
    steps = %w[basic_info user_info job_employment asset_details bank_details]
    completed = session[:completed_steps] || []
    steps.find { |s| !completed.include?(s) } || "basic_info"
  end


  #validate form step by step not navigate user next form without fill previous form
  def validate_step(user, step)
    user.current_step = step

    case step
    when "basic_info"
      user.valid?
      !user.errors.include?(:name) &&
        !user.errors.include?(:email) &&
        !user.errors.include?(:password)

    when "user_info"
      if user.user_info.present?
        user.user_info.valid?
        user.user_info.errors.empty?
      else
        false
      end

    when "job_employment"
      user.job_employments.each(&:valid?) if user.job_employments.present?
      user.job_employments.present? && user.job_employments.all? { |je| je.errors.empty? }

    when "asset_details"
      user.asset_details.each(&:valid?) if user.asset_details.present?
      user.asset_details.present? && user.asset_details.all? { |ad| ad.errors.empty? }

    when "bank_details"
      user.bank_details.each(&:valid?) if user.bank_details.present?
      user.bank_details.present? && user.bank_details.all? { |bd| bd.errors.empty? }

    else
      false
    end
  end

  def next_step(current_step)
    #navigating next steps
    index = STEPS.index(current_step)
    return nil if index.nil? || index == STEPS.size - 1
    STEPS[index + 1]
  end
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
