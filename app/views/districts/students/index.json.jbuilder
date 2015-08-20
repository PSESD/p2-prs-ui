json.array!(@districts_students) do |districts_student|
  json.extract! districts_student, :id
  json.url districts_student_url(districts_student, format: :json)
end
