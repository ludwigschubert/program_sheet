class TotalUnitsConstraint < Constraint

  def minimum_units
    self.options['minimum_units'] or 45
  end

  def maximum_foundation_units
    self.options['maximum_foundation_units'] or 10
  end

  def foundations
    FoundationsConstraint::FOUNDATIONS - self.waivers
  end

  def foundation_enrollments
    self.enrollments.select do |enrollment|
      foundations.include?(enrollment.course.code)
    end
  end

  def non_foundation_enrollments
    self.enrollments.select do |enrollment|
      not foundations.include?(enrollment.course.code)
    end
  end

  def foundations_units
    [foundation_enrollments.map(&:units).reduce(:+), maximum_foundation_units].min
  end

  def non_foundations_units
    non_foundation_enrollments.map(&:units).reduce(:+)
  end

  def satisfied?
    # Cap foundation units at ten, even if enrolled for more to keep at status
    units = foundations_units + non_foundations_units
    unless units >= minimum_units
      self.errors << "Only have #{units} of at least #{minimum_units} units!"
    end
    self.errors.empty?
  end

  def by
    "Taking #{foundations_units} foundation units and #{non_foundations_units} general units."
  end

  def to_s
    "Minimum of #{minimum_units} units with maximum #{maximum_foundation_units} foundation units"
  end
end