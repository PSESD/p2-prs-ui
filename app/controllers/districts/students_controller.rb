class Districts::StudentsController < DistrictsController
  before_action :set_district
  before_action :set_districts_service
  before_action :set_districts_student, only: [:show, :edit, :update, :destroy, :filters]

  # GET /districts/students
  # GET /districts/students.json
  def index
    @students = District::Student.all(district_id: params[:district_id], service_id: params[:service_id])
  end

  # GET /districts/students/1
  # GET /districts/students/1.json
  def show
  end

  # GET /districts/students/new
  def new
    @student = District::Student.new
  end

  # GET /districts/students/1/edit
  def edit
  end

  # POST /districts/students
  # POST /districts/students.json
  def create
    return bulk_create # if districts_student_params[:districtStudentId].include?(",")
    # @student = District::Student.new(districts_student_params)
    #
    # respond_to do |format|
    #   if @student.create
    #     format.html { redirect_to [@district, @service], notice: 'Student was successfully created.' }
    #     format.json { render :show, status: :created, location: [@district, @service, @student] }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @student.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # Create a bunch of students at once.
  def bulk_create
# byebug

    # unless params[:id]
      # begin
        # Resque.enqueue(CreateStudentsWorker, districts_student_params)
        # @job_id = CreateStudentsWorker.create(districts_student_params)
      # rescue ActiveRestClient::HTTPClientException, ActiveRestClient::HTTPServerException => e
        # Rails.logger.error("API returned #{e.status} : #{e.result.message}")
      # end

      student_ids = districts_student_params[:districtStudentId].split(",").map(&:strip)
      districts_student_params[:districtServiceId] = districts_student_params[:service_id]

      total = student_ids.count
      student_ids.each_with_index do |student_id, i|
        puts "Creating #{i + 1} of #{total}"
        districts_student_params[:districtStudentId] = student_id
        path = "/districts/" + districts_student_params[:district_id] + "/services/" + districts_student_params[:service_id] + "/students"
        http_request("post", path, districts_student_params.to_json)
      end

      redirect_to district_service_path(district_id: @district.id, id: @service.id)
      # redirect_to(bulk_create_status_district_service_students_path(district_id: @district, service_id: @service, id: @job_id))
    # end

    # @status = Resque::Plugins::Status::Hash.get(params[:id])
    # respond_to do |format|
    #   if @status
    #     format.html { render :bulk_create }
    #     format.json { render :show, status: :created, location: [@district, @service, :students, :bulk_create] }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @status.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /districts/students/1
  # PATCH/PUT /districts/students/1.json
  def update
    respond_to do |format|
      if @student.update(districts_student_params)
        format.html { redirect_to [@district, @service], notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: [@district, @service, @student] }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /districts/students/1
  # DELETE /districts/students/1.json
  def destroy
    @student.destroy(district_id: @district.id, service_id: @service.id, id: params[:id])
    respond_to do |format|
      format.html { redirect_to [@district, @service], notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def filters
    @student.filters(
      zoneid: @district.zoneID,
      districtId: @district.id,
      authorizedEntityId: @service.authorizedEntityId,
      externalServiceId: @service.externalServiceId,
      districtStudentId: @student.districtStudentId,
      objectType: (params[:object_type] || "xSre")
    )
  rescue ActiveRestClient::ResponseParseException => e
    render inline: CodeRay.scan(e.body, :xml).html(
      :wrap => nil,
      :css => :style
    )
  end

  private

  def set_districts_service
    @service = District::Service.find(district_id: @district.id, id: params[:service_id]).first
  end

  def set_districts_student
    @student = District::Student.find(district_id: @district.id, service_id: params[:service_id], id: params[:id]).first
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def districts_student_params
    params[:student][:district_id] = @district.id
    params[:student][:service_id] = @service.id
    params[:student]
  end

  def districts_student_params_json
    districts_student_params.to_json
  end
end
