class UnitsConstraint < Constraint

  MIN_UNITS = 8 # at least for internationals
  MAX_UNITS = 10 # at least for RAships

  def satisfied?
    self.enrollments.group_by(&:quarter).map do |quarter, enrollments|
      units = enrollments.map(&:units).reduce(:+)
      unless MIN_UNITS <= units and  MAX_UNITS >= units
        self.errors << quarter.to_s.bold + " has " + units.to_s.bold.red + " units!"
      end
    end
    self.errors.empty?
  end
end