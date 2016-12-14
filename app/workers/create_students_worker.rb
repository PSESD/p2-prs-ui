class CreateStudentsWorker
  include Resque::Plugins::Status
  # @queue = :students

  # def perform
  #   params = options.dup
  #   ids = params['districtStudentId'].try(:split, ",").try(:collect, &:strip)
  #
  #   @students = {}
  #   ids.each_with_index do |id, index|
  #     params['districtStudentId'] = id
  #     at(index+1, ids.size, "Creating #{index} of #{ids.size}")
  #     @students[id] = District::Student.create(params)
  #     set_status(students: @students)
  #   end
  #
  #   completed(students: @students)
  # end

  def self.perform(districts_student_params)
    student_ids = districts_student_params[:districtStudentId].split(",").map(&:strip)
    districts_student_params[:districtServiceId] = districts_student_params[:service_id]

    total = student_ids.count
    student_ids.each_with_index do |student_id, i|
      puts "Creating #{i + 1} of #{total}"
      districts_student_params[:districtStudentId] = student_id
      path = "/districts/" + districts_student_params[:district_id] + "/services/" + districts_student_params[:service_id] + "/students"
      http_request("post", path, districts_student_params.to_json)
    end
  end
end
