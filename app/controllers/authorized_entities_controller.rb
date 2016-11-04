class AuthorizedEntitiesController < ApplicationController
  before_action :set_authorized_entity, only: [:show, :edit, :update, :destroy]

  # GET /authorizedEntities
  # GET /authorizedEntities.json
  def index
    @authorized_entities = AuthorizedEntity.all
  end

  # GET /authorizedEntities/1
  # GET /authorizedEntities/1.json
  def show
    @services = AuthorizedEntity::Service.all(authorized_entity_id: @authorized_entity.id)
  end

  # GET /authorizedEntities/new
  def new
    @authorized_entity = AuthorizedEntity.new
  end

  # GET /authorizedEntities/1/edit
  def edit
  end

  # POST /authorizedEntities
  # POST /authorizedEntities.json
  def create
    @authorized_entity = AuthorizedEntity.new(authorized_entity_params)

    respond_to do |format|
      if @authorized_entity.create
        format.html { redirect_to @authorized_entity, notice: 'Authorized entity was successfully created.' }
        format.json { render :show, status: :created, location: @authorized_entity }
      else
        format.html { render :new }
        format.json { render json: @authorized_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorizedEntities/1
  # PATCH/PUT /authorizedEntities/1.json
  def update
    respond_to do |format|
      if @authorized_entity.update(authorized_entity_params)
        format.html { redirect_to @authorized_entity, notice: 'Authorized entity was successfully updated.' }
        format.json { render :show, status: :ok, location: @authorized_entity }
      else
        format.html { render :edit }
        format.json { render json: @authorized_entity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authorizedEntities/1
  # DELETE /authorizedEntities/1.json
  def destroy
    @authorized_entity.destroy
    respond_to do |format|
      format.html { redirect_to authorizedEntities_url, notice: 'Authorized entity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authorized_entity
      @authorized_entity = AuthorizedEntity.find(params[:authorized_entity_id] || params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authorized_entity_params
      params.require(:authorized_entity).permit(:authorizedEntityName, { mainContact: %w[name title email phone mailingAddress webAddress] })
    end
end
