class Districts::ServicesController < DistrictsController
  before_action :set_district
  before_action :set_service, only: [:show, :edit, :update, :destroy]

  helper_method :student_filtered

  # GET /district/services
  # GET /district/services.json
  def index
    @services = District::Service.all("/districts/#{@district.id}/services")
  end

  # GET /district/services/1
  # GET /district/services/1.json
  def show
    @students = @service.students
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
    service = http_request("post", "/districts/#{@district.id}/services", service_params_json)
    @service = JSON.parse(service)

    respond_to do |format|
      if !@service.keys.include?("error")
        format.html { redirect_to [@district, @service], notice: 'Organization was successfully authorized.' }
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
    service = http_request("put", "/districts/#{@district.id}/services/#{@service.id}", service_params_json)
    json_service = JSON.parse(service)
    @service = District::Service.new(json_service)

    respond_to do |format|
      if @service
        format.html { redirect_to [@district, @service], notice: 'Authorization was successfully updated.' }
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
    District::Service.destroy("/districts/#{@district.id}/services/#{@service.id}")
    respond_to do |format|
      format.html { redirect_to @district, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_service
      route = "/districts/#{@district.id}/services/" + (params[:id])
      @service = District::Service.find(route)
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
