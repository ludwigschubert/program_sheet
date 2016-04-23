class CourseSubsetConstraint < Constraint
  attr_accessor :courses_for_subset

  def course_subset
    self.options['courses'] or []
  end

  def minimum_number
    self.options['minimum_number'] or 1 #!!!
  end

  def satisfied?
    relevant_courses_taken = self.enrollments.map(&:course).map(&:code).select do |course_code|
      course_subset.include? course_code
    end
    relevant_courses_waived = self.waivers & course_subset
    self.courses_for_subset = relevant_courses_taken + relevant_courses_waived
    delta =  minimum_number - courses_for_subset.length
    if delta > 0
      self.errors << "Missing #{delta} courses from #{course_subset - courses_for_subset}!"
    end
    self.errors.empty?
  end

  def by
    self.courses_for_subset.join(", ")
  end

  def to_s
    "Take at least #{minimum_number} of #{course_subset}"
  end
end