class Enroller
  attr_accessor :quarters, :enrollments, :waivers
  vattr_initialize :enrollments_sheet, :courses do

    self.quarters = self.enrollments_sheet["Quarters"].keys.map do |quarter_string|
      season, year = quarter_string.split
      Quarter.new year.to_i, season.downcase
    end

    self.enrollments = []
    self.enrollments_sheet["Quarters"].each do |quarter_string, course_unit_strings|
      course_unit_strings.each do |course_unit_string|
        course_string, units = course_unit_string.split(', ')
        self.enrollments << enroll(course_string, quarter_string, units.to_i)
      end
    end

    self.waivers = self.enrollments_sheet["Waivers"]
  end

  private

  def enroll course_string, quarter_string, units

    course = self.courses.select do |course|
      course.code == course_string
    end.first
    raise "Could not find course with code #{course_string}!" unless course

    quarter = self.quarters.select do |quarter|
      quarter.to_s == quarter_string
    end.first
    raise "Could not find quarter #{quarter_string}!" unless quarter

    enrollment = CourseEnrollment.new course, quarter, units

    if enrollment.valid?
      enrollment
    else
      raise "Not a valid enrollment: " + enrollment.errors.join(", ")
    end
  end
end