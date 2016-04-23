class CourseUnitSubsetConstraint < Constraint
  attr_accessor :units_for_subset

  def course_subset
    self.options['courses'] or []
  end

  def minimum_units
    self.options['minimum_units']
  end

  def satisfied?
    relevant_enrollments = self.enrollments.select do |enrollment|
      course_subset.include? enrollment.course.code
    end
    self.units_for_subset = relevant_enrollments.map(&:units).reduce(:+)
    if self.units_for_subset < minimum_units
      self.errors << "Missing #{minimum_units - self.units_for_subset} units (Need #{minimum_units}, enrolled in #{self.units_for_subset})!"
    end
    self.errors.empty?
  end

  def by
    "Taking #{self.units_for_subset}."
  end

  def to_s
    "Need #{minimum_units}."
  end
end