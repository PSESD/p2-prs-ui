class CreateStudentsWorker
  include Resque::Plugins::Status
  @queue = :students

  def perform
    params = options.dup
    ids = params['districtStudentId'].try(:split, ",").try(:collect, &:strip)
    
    @students = {}
    ids.each_with_index do |id, index|
      params['districtStudentId'] = id
      at(index+1, ids.size, "Creating #{index} of #{ids.size}")
      @students[id] = District::Student.create(params)
      set_status(students: @students)
    end
    
    completed(students: @students)
  end
end
