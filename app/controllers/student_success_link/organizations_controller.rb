class StudentSuccessLink::OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy, :add_admin_user]

  # GET /student_success_link/organizations
  # GET /student_success_link/organizations.json
  def index
    @organizations = StudentSuccessLink::Organization.all
  end

  # GET /student_success_link/organizations/1
  # GET /student_success_link/organizations/1.json
  def show
  end

  # GET /student_success_link/organizations/new
  def new
    @organization = StudentSuccessLink::Organization.new(organization_params)
  end

  # GET /student_success_link/organizations/1/edit
  def edit
  end

  # POST /student_success_link/organizations
  # POST /student_success_link/organizations.json
  def create
    @organization = StudentSuccessLink::Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to @organization, notice: 'Organization was successfully created.' }
        format.json { render :show, status: :created, location: @organization }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /student_success_link/organizations/1
  # PATCH/PUT /student_success_link/organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Organization was successfully updated.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /student_success_link/organizations/1
  # DELETE /student_success_link/organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to student_success_link_organizations_url, notice: 'Organization was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def add_admin_user
    @user = StudentSuccessLink::User.find(params[:user_id])
    
    respond_to do |format|
      if @organization.add_admin_user(@user)
        format.html { redirect_to @organization, notice: 'User was added successfully.' }
        format.json { render json: @organization }
      else
        flash[:error] = "Could not add admin user: #{@user.errors.full_messages.join(", ")}"
        format.html { render :show }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = StudentSuccessLink::Organization.find(params[:organization_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:student_success_link_organization).permit(:name, :description, :website, :url, :authorizedEntityId, :externalServiceId)
    end
end
