class DataSets::DataObjectsController < DataSetsController
  before_action :set_data_set
  before_action :set_data_object, only: [:show, :edit, :update, :destroy]

  # GET /data_sets/data_objects
  # GET /data_sets/data_objects.json
  def index
    @data_objects = @data_set.dataObjects.group_by(&:sifObjectName)
  end

  # GET /data_sets/data_objects/1
  # GET /data_sets/data_objects/1.json
  def show
  end

  # GET /data_sets/data_objects/new
  def new
    @data_object = DataSet::DataObject.new
  end

  # GET /data_sets/data_objects/1/edit
  def edit
  end

  # POST /data_sets/data_objects
  # POST /data_sets/data_objects.json
  def create
    @data_object = post("dataSets/#{@data_set.id}/sifDataObjects", data_object_params_json)

    respond_to do |format|
      if @data_object = JSON.parse(@data_object)
        format.html { redirect_to @data_set, notice: 'Data object was successfully created.' }
        format.json { render :show, status: :created, location: @data_set }
      else
        format.html { render :new }
        format.json { render json: @data_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /data_sets/data_objects/1
  # PATCH/PUT /data_sets/data_objects/1.json
  def update
    respond_to do |format|
      if @data_object.update(data_sets_data_object_params)
        format.html { redirect_to @data_set, notice: 'Data object was successfully updated.' }
        format.json { render :show, status: :ok, location: @data_set }
      else
        format.html { render :edit }
        format.json { render json: @data_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_sets/data_objects/1
  # DELETE /data_sets/data_objects/1.json
  def destroy
    @data_object.destroy(data_set_id: @data_set.id, id: params[:id])
    respond_to do |format|
      format.html { redirect_to @data_set, notice: 'Data object was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_object
      @data_object = DataSet::DataObject.find(data_set_id: @data_set.id, id: params[:id]).items.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_object_params
      params[:data_object][:data_set_id] = @data_set.id
      params[:data_object]
    end

    def data_object_params_json
      data_set_params.to_json
    end

    def data_object_params_xml
      JSON.parse(data_set_params_json).to_xml(root: :dataSet)
    end
end
