class CourseEnrollment
  attr_accessor :errors
  vattr_initialize :course, :quarter, :units do
    self.errors = []
  end

  def valid?

    unless self.course.unit_range.member? self.units
      self.errors << "#{course} #{quarter}: #{self.units} is outside of #{self.course.unit_range.to_a.join(', ')}"
    end

    unless self.course.seasons.include? self.quarter.season
      self.errors << "#{course} #{quarter}: #{self.quarter.season} is not one of #{self.course.seasons.join(', ')}"
    end

    self.errors.empty?
  end

  def to_s
    desc = "  " + course.code.to_s.bold + " for #{units} units "
    if alternative_seasons.any?
      desc += "(also in #{(alternative_seasons).join(', ')})"
    end
    desc.light_white
  end

  private

    def alternative_seasons
      course.seasons - [quarter.season]
    end
end