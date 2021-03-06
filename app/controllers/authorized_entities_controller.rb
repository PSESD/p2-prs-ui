class AuthorizedEntitiesController < ApplicationController
  before_action :set_authorized_entity, only: [:show, :edit, :update, :destroy, :data_sharing_agreement]
  before_action :set_service, only: [:show, :edit, :update]

  # GET /authorized_entities
  # GET /authorized_entities.json
  def index
    @authorized_entities = AuthorizedEntity.all("/authorizedEntities")
  end

  # GET /authorized_entities/1
  # GET /authorized_entities/1.json
  def show
    @districts = District.all("/districts")
    @district_services = @service.district_services(@districts)
  end

  # GET /authorized_entities/new
  def new
    @authorized_entity = AuthorizedEntity.new
    @service = AuthorizedEntity::Service.new
  end

  # GET /authorized_entities/1/edit
  def edit
  end

  # POST /authorized_entities
  # POST /authorized_entities.json
  def create
    authorized_entity = http_request("post", "/authorizedEntities", authorized_entity_params_json)
    @authorized_entity = JSON.parse(authorized_entity)

    create_external_service

    respond_to do |format|
      if !@authorized_entity.keys.include?("error")
        format.html { redirect_to authorized_entity_path(@authorized_entity["id"]), notice: 'Authorized entity was successfully created.' }
        format.json { render :show, status: :created, location: authorized_entity_path(@authorized_entity["id"]) }
      else
        format.html { render :new }
        format.json { render json: @authorized_entity["errors"], status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorized_entities/1
  # PATCH/PUT /authorized_entities/1.json
  def update
    authorized_entity = http_request("put", "/authorizedEntities/#{@authorized_entity.id}", authorized_entity_params_json)
    @authorized_entity = JSON.parse(authorized_entity)

    update_external_service

    respond_to do |format|
      if !@authorized_entity.keys.include?("error")
        format.html { redirect_to @authorized_entity, notice: 'Authorized entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @authorized_entity }
      else
        format.html { render :edit }
        format.json { render json: @authorized_entity["errors"], status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorized_entities/1
  # DELETE /authorized_entities/1.json
  def destroy
    AuthorizedEntity.destroy("/authorizedEntities/" + @authorized_entity.id)
    respond_to do |format|
      format.html { redirect_to authorized_entities_url, notice: 'Authorized entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def data_sharing_agreement
    @body_class = "data_sharing_agreement"
    @container_class = "container-fluid"
  end

  def authorized_entity_param_json
    JSON.parse(authorized_entity_params.to_json)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorized_entity
      route = "/authorizedEntities/" + (params[:authorized_entity_id] || params[:id])
      @authorized_entity = AuthorizedEntity.find(route)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorized_entity_params
      ae_params = params.require(:authorized_entity).permit(:name, :externalServiceDescription, { mainContact: %w[name title email phone mailingAddress webAddress] })
      ae_params[:mainContact][:webAddress] = ae_params[:mainContact][:webAddress] + ".studentsuccesslink.org"
      ae_params
    end

    def authorized_entity_params_json
      authorized_entity_params.to_json
    end

    def authorized_entity_params_xml
      JSON.parse(authorized_entity_params_json).to_xml(root: :authorizedEntity)
    end

    # External Service
    def set_service
      services = AuthorizedEntity::Service.all("/authorizedEntities/#{@authorized_entity.id}/services")
      @service = services.find { |service| service.authorizedEntityId == @authorized_entity.id }
    end

    def create_external_service
      http_request("post", "/authorizedEntities/#{@authorized_entity["id"]}/services", service_params_json)
    end

    def update_external_service
      http_request("put", "/authorizedEntities/#{@authorized_entity["id"]}/services/#{@service.id}", service_params_json)
    end

    def service_params
      { "authorized_entity_id"        => @authorized_entity["id"],
         "externalServiceDescription" => authorized_entity_params["externalServiceDescription"] }
    end

    def service_params_json
      service_params.to_json
    end
end
