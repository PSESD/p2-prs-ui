class StudentWorker
  include Resque::Plugins::Status

  @queue = :students

  # def self.perform(districts_student_params)
  #   student_ids = districts_student_params["districtStudentId"].split(",").map(&:strip)
  #
  #   total = student_ids.count
  #   student_ids.each_with_index do |student_id, i|
  #     puts "Creating #{i + 1} of #{total}"
  #     districts_student_params["districtStudentId"] = student_id
  #     path = "/districts/" + districts_student_params["district_id"] + "/services/" + districts_student_params["service_id"] + "/students"
  #
  #     District::Student.create(path, districts_student_params.to_json)
  #   end
  # end

  def perform
    student_ids = options["districtStudentId"].split(",").map(&:strip)

    total = student_ids.count
    student_ids.each_with_index do |student_id, i|
      puts "Creating #{i + 1} of #{total}"
      options["districtStudentId"] = student_id
      path = "/districts/" + options["district_id"] + "/services/" + options["service_id"] + "/students"

      District::Student.create(path, options.to_json)
    end
  end


  # def self.perform(districts_student_params)
  #     puts "Creating #{districts_student_params["current"]} of #{districts_student_params["total"]}"
  #     path = "/districts/" + districts_student_params["district_id"] + "/services/" + districts_student_params["service_id"] + "/students"
  #     District::Student.create(path, districts_student_params.to_json)
  # end

  # def perform(districts_student_params, i, total)
  #     puts "Creating #{i + 1} of #{total}"
  #     path = "/districts/" + districts_student_params["district_id"] + "/services/" + districts_student_params["service_id"] + "/students"
  #     District::Student.create(path, districts_student_params.to_json)
  # end
end
