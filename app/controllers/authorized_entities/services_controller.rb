class AuthorizedEntities::ServicesController < AuthorizedEntitiesController
  before_action :set_authorized_entity
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /authorized_entity/services
  # GET /authorized_entity/services.json
  def index
    route = "/authorizedEntities/#{@authorized_entity.id}/services"
    @authorized_entity_services = AuthorizedEntity::Service.all(route)
  end

  # GET /authorized_entity/services/1
  # GET /authorized_entity/services/1.json
  def show
    @districts = District.all("/districts")
    @district_services = @service.district_services(@districts)
  end

  # GET /authorized_entity/services/new
  def new
    @service = AuthorizedEntity::Service.new
  end

  # GET /authorized_entity/services/1/edit
  def edit
  end

  # POST /authorized_entity/services
  # POST /authorized_entity/services.json
  def create
    service = http_request("post", "/authorizedEntities/#{@authorized_entity.id}/services", service_params_json)
    @service = JSON.parse(service)

    respond_to do |format|
      if !@service.keys.include?("error")
        format.html { redirect_to [@authorized_entity, @service], notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: [@authorized_entity, @service] }
      else
        @service = AuthorizedEntity::Service.new
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorized_entity/services/1
  # PATCH/PUT /authorized_entity/services/1.json
  def update
    service = http_request("put", "/authorizedEntities/#{@authorized_entity.id}/services/#{@service.id}", service_params_json)
    @service = JSON.parse(service)

    respond_to do |format|
      if !@service.keys.include?("error")
        format.html { redirect_to [@authorized_entity, @service], notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: [@authorized_entity, @service] }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorized_entity/services/1
  # DELETE /authorized_entity/services/1.json
  def destroy
    AuthorizedEntity::Service.destroy("/authorizedEntities/#{@authorized_entity.id}/services/" + @service.id)
    respond_to do |format|
      format.html { redirect_to @authorized_entity, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def create_organization_admin(organization, authorized_entity)
      contact = @authorized_entity.mainContactObject
      organization.create_admin_user(contact.email, contact.name)
    end

    def create_organization_record(authorized_entity, service_id)
      org_params = organization_params(authorized_entity, service_id)

      organization = StudentSuccessLink::Organization.new(org_params)
      organization.save

      create_organization_admin(organization, authorized_entity)
    end

    def organization_params(authorized_entity, service_id)
      contact = authorized_entity.mainContactObject

      { name: authorized_entity.name,
        website: contact.fullWebAddress,
        url: organization_url,
        authorizedEntityId: authorized_entity.id,
        externalServiceId: service_id,
        created_at: DateTime.now,
        updated_at: DateTime.now }
    end

    def organization_url
      Rails.application.secrets.organization_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_service
      route = "/authorizedEntities/#{@authorized_entity.id}/services/#{params[:id]}"
      @service = AuthorizedEntity::Service.find(route)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params[:service][:authorized_entity_id] = @authorized_entity.id
      params[:service]
    end

    def service_params_json
      service_params.to_json
    end

    def service_params_xml
      JSON.parse(service_params_json).to_xml(root: :authorizedEntity)
    end
end
