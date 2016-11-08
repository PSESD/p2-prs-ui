class DistrictsController < ApplicationController
  before_action :set_district, only: [:show, :edit, :update, :destroy, :consent_form]

  # GET /districts
  # GET /districts.json
  def index
    @districts = District.all
  end

  # GET /districts/1
  # GET /districts/1.json
  def show
    @services = District::Service.all(district_id: @district.id)
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
    @district = District.post(:create, nil, district_params_xml)

    respond_to do |format|
      if District.post(:create, nil, district_params_xml)
        # need id num of last district created to render view
        format.html { redirect_to @district, notice: 'District was successfully created.' }
        format.json { render :show, status: :created, location: @district }
      else
        format.html { render :new }
        format.json { render json: @district.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /districts/1
  # PATCH/PUT /districts/1.json
  def update
    respond_to do |format|
      if @district.update(district_params)
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
    @district.destroy
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

    @services = params[:services].collect{ |id| District::Service.find(district_id: @district.id, id: id) }
    @dataSets = @services.collect{ |d| d.dataSets }
    return redirect_to(:back, alert: mismatched_datasets_alert) if @dataSets.collect{|d| d.collect(&:id) }.uniq.size > 1
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
      @district = District.find(params[:district_id] || params[:id]).first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def district_params
      params.require(:district).permit(:districtName, :ncesleaCode, :zoneID, mainContact: %w[name title email phone mailingAddress webAddress] )
    end

    def district_params_xml
      JSON.parse(district_params.to_json).to_xml(root: :districts)
    end
end
