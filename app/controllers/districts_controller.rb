class DistrictsController < ApplicationController
  before_action :set_district, only: [:show, :edit, :update, :destroy, :consent_form]

  # GET /districts
  # GET /districts.json
  def index
    @districts = District.all("/districts")
  end

  # GET /districts/1
  # GET /districts/1.json
  def show
    @services = District::Service.all("/districts/#{@district.id}/services")
  end

  # GET /districts/new
  def new
    @district = District.new
  end

  # GET /districts/1/edit
  def edit
  end

  # POST /districts
  # POST /districts.json
  def create
    district = http_request("post", "/districts", district_params_json)
    # district = District.create("/districts", district_params_json)
    json_district = JSON.parse(district)
    @district = District.new(json_district)

    respond_to do |format|
      if @district
        format.html { redirect_to @district, notice: 'District was successfully created.' }
        format.json { render :show, status: :created, location: @district }
        format.xml { render :show, status: :created, location: @district }
      else
        format.html { render :new }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /districts/1
  # PATCH/PUT /districts/1.json
  def update
    district = http_request("put", "/districts/#{@district.id}", district_params_json)
    @district = JSON.parse(district)

    respond_to do |format|
      if !@district.keys.include?("error")
        format.html { redirect_to @district, notice: 'District was successfully updated.' }
        format.json { render :show, status: :ok, location: @district }
      else
        format.html { render :edit }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /districts/1
  # DELETE /districts/1.json
  def destroy
    District.destroy("/districts/" + @district.id)
    respond_to do |format|
      format.html { redirect_to districts_url, notice: 'District was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def consent_form
    empty_list_alert = "Please select at least one organization to include on the form and try again."
    mismatched_datasets_alert = "All organizations must have the same datasets in order to be included on the same form."
    mismatched_expiration_alert = "All organizations must have the same expiration date in order to be included on the same form."
    return redirect_to(:back, alert: empty_list_alert) unless params[:services]

    @services = params[:services].map { |id| District::Service.find("/districts/#{@district.id}/services/" + id) }
    @authorized_entities = @services.map { |service| service.authorized_entity }
    @dataSets = @services.map { |service| DataSet.create_objects(service.dataSets) }.flatten

    # return redirect_to(:back, alert: mismatched_datasets_alert) if @dataSets.collect(&:id).uniq.size > 1
    return redirect_to(:back, alert: mismatched_expiration_alert) if @services.collect(&:expirationDate).uniq.size > 1

    @approval_range = [Date.today.year, @services.first.expirationDate.try(&:year)].uniq
    @body_class = "consent_form"
    @container_class = "container-fluid"
    @services_title = (@services.size > 1) ? "Multiple Organizations" : @services.first.name
    @page_title = "#{@approval_range.join("-")} CBO Parent/Guardian Consent Form - #{@services_title}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_district
      route = "/districts/" + (params[:district_id] || params[:id])
      @district = District.find(route)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def district_params
      incoming_params = params.require(:district).permit(:name, :ncesleaCode, :zoneId, main_contact: %w[name title email phone mailingAddress webAddress] )

      set_mainContact(incoming_params)
    end

    def district_params_json
      district_params.to_json
    end

    def district_params_xml
      JSON.parse(district_params_json).to_xml(root: :district)
    end

    def set_mainContact(incoming_params)
      contact = incoming_params[:main_contact]
      incoming_params[:mainContact] = contact
      incoming_params
    end
end
