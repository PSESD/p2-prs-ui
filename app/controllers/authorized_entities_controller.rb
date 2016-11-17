class AuthorizedEntitiesController < ApplicationController
  before_action :set_authorized_entity, only: [:show, :edit, :update, :destroy]

  # GET /authorized_entities
  # GET /authorized_entities.json
  def index
    @authorized_entities = AuthorizedEntity.all.items
  end

  # GET /authorized_entities/1
  # GET /authorized_entities/1.json
  def show
    services = AuthorizedEntity::Service.all(authorized_entity_id: @authorized_entity.id).items
    @services = services.select { |service| service.authorizedEntityId == @authorized_entity.id }
  end

  # GET /authorized_entities/new
  def new
    @authorized_entity = AuthorizedEntity.new
  end

  # GET /authorized_entities/1/edit
  def edit
    # byebug
  end

  # POST /authorized_entities
  # POST /authorized_entities.json
  def create
    @authorized_entity = post("/authorizedEntities", authorized_entity_params_json)
    @authorized_entity = JSON.parse(@authorized_entity)

    respond_to do |format|
      if !@authorized_entity.keys.include?("error")
        format.html { redirect_to @authorized_entity, notice: 'Authorized entity was successfully created.' }
        format.json { render :show, status: :created, location: @authorized_entity }
      else
        format.html { render :new }
        format.json { render json: @authorized_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorized_entities/1
  # PATCH/PUT /authorized_entities/1.json
  def update
    # byebug
    authorized_entity = put("/authorizedEntities/#{@authorized_entity.id}", authorized_entity_params_json)
    @authorized_entity = JSON.parse(authorized_entity)

    respond_to do |format|
      if !@authorized_entity.keys.include?("error")
        format.html { redirect_to @authorized_entity, notice: 'Authorized entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @authorized_entity }
      else
        format.html { render :edit }
        format.json { render json: @authorized_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorized_entities/1
  # DELETE /authorized_entities/1.json
  def destroy
    @authorized_entity.destroy
    respond_to do |format|
      format.html { redirect_to authorized_entities_url, notice: 'Authorized entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def authorized_entity_param_json
    JSON.parse(authorized_entity_params.to_json)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorized_entity
      @authorized_entity = AuthorizedEntity.find(params[:authorized_entity_id] || params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorized_entity_params
      params.require(:authorized_entity).permit(:name, { mainContact: %w[name title email phone mailingAddress webAddress] })
    end

    def authorized_entity_params_json
      authorized_entity_params.to_json
    end

    def authorized_entity_params_xml
      JSON.parse(authorized_entity_params_json).to_xml(root: :authorizedEntity)
    end
end
