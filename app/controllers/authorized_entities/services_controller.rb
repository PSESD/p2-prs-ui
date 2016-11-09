class AuthorizedEntities::ServicesController < AuthorizedEntitiesController
  before_action :set_authorized_entity
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /authorized_entity/services
  # GET /authorized_entity/services.json
  def index
    @services = AuthorizedEntity::Service.all
  end

  # GET /authorized_entity/services/1
  # GET /authorized_entity/services/1.json
  def show
    @districts = District.all
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
    @service = AuthorizedEntity::Service.new(service_params)

    respond_to do |format|
      if @service.create
        format.html { redirect_to [@authorized_entity, @service], notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: [@authorized_entity, @service] }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authorized_entity/services/1
  # PATCH/PUT /authorized_entity/services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
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
    @service.destroy
    respond_to do |format|
      format.html { redirect_to @authorized_entity, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = AuthorizedEntity::Service.find(authorized_entity_id: params[:authorized_entity_id], id: params[:id]).items.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params[:service][:authorized_entity_id] = @authorized_entity.id
      params[:service]
    end
end
