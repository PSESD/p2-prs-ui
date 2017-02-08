class DataSetsController < ApplicationController
  before_action :set_data_set, only: [:show, :edit, :update, :destroy]

  # GET /data_sets
  # GET /data_sets.json
  def index
    @data_sets = DataSet.all("/dataSets")
  end

  # GET /data_sets/1
  # GET /data_sets/1.json
  def show
    @data_objects = @data_set.data_objects_instantiated.group_by(&:sifObjectName)
  end

  # GET /data_sets/new
  def new
    @data_set = DataSet.new
  end

  # GET /data_sets/1/edit
  def edit
  end

  # POST /data_sets
  # POST /data_sets.json
  def create
    data_set = http_request("post", "/dataSets", data_set_params_json)
    @data_set = JSON.parse(data_set)

    respond_to do |format|
      if !@data_set.keys.include?("error")
        format.html { redirect_to @data_set, notice: 'Data set was successfully created.' }
        format.json { render :show, status: :created, location: @data_set }
      else
        format.html { render :new }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_sets/1
  # PATCH/PUT /data_sets/1.json
  def update
    data_set = http_request("put", "/dataSets/#{@data_set.id}", data_set_params_json)
    @data_set = JSON.parse(data_set)

    respond_to do |format|
      if !@data_set.keys.include?("error")
        format.html { redirect_to @data_set, notice: 'Data set was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_set }
      else
        format.html { render :edit }
        format.json { render json: @data_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sets/1
  # DELETE /data_sets/1.json
  def destroy
    DataSet.destroy("/dataSets/" + @data_set.id)
    respond_to do |format|
      format.html { redirect_to data_sets_url, notice: 'Data set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_set
      route = "/dataSets/" + (params[:data_set_id] || params[:id])
      @data_set = DataSet.find(route)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_set_params
      params.require(:data_set).permit(:name, :description)
    end

    def data_set_params_json
      data_set_params.to_json
    end

    def data_set_params_xml
      JSON.parse(data_set_params_json).to_xml(root: :dataSet)
    end
end
