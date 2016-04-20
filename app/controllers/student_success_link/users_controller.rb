class StudentSuccessLink::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  
  # GET /student_success_link/users
  # GET /student_success_link/users.json
  def index
    @users = StudentSuccessLink::User.where("permissions.role" => "admin" ).order_by(last_name: :asc, first_name: :asc)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = StudentSuccessLink::User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:student_success_link_user).permit(:first_name, :last_name, :email)
    end
end
