class Districts::ServicesController < DistrictsController
  before_action :set_district
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  # GET /district/services
  # GET /district/services.json
  def index
    @services = District::Service.all(district_id: @district.id)
  end

  # GET /district/services/1
  # GET /district/services/1.json
  def show
  end

  # GET /district/services/new
  def new
    @service = District::Service.new
    @service.externalServiceId = params[:externalServiceId] if params[:externalServiceId]
    @service.new_record = true
  end

  # GET /district/services/1/edit
  def edit
  end

  # POST /district/services
  # POST /district/services.json
  def create
    @service = post("districts/#{@district.id}/services", service_params_json)

    respond_to do |format|
      if @service = JSON.parse(@service)
        format.html { redirect_to [@district, @service], notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: [@district, @service] }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /district/services/1
  # PATCH/PUT /district/services/1.json
  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to [@district, @service], notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: [@district, @service] }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /district/services/1
  # DELETE /district/services/1.json
  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to @district, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      @service = District::Service.find(district_id: params[:district_id], id: params[:id]).items.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def service_params
      params[:service][:district_id] = @district.id
      params[:service]
    end

    def service_params_json
      service_params.to_json
    end

    def service_params_xml
      JSON.parse(service_params_json).to_xml(root: :district)
    end
end
