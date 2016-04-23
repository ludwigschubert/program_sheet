class FoundationsConstraint < Constraint

  FOUNDATIONS = ["CS 103", "CS 109", "CS 161", "CS 107", "CS 110"]
  attr_accessor :relevant_enrollments

  def satisfied?
    self.relevant_enrollments = []
    foundations = FOUNDATIONS - self.waivers
    self.enrollments.each do |enrollment|
      course_code = foundations.delete enrollment.course.code
      self.relevant_enrollments << course_code if course_code
    end
    foundations.each do |missing_foundation|
      self.errors << "Missing foundation #{missing_foundation}!"
    end
    self.errors.empty?
  end

  def relevant_waivers
    self.waivers & FOUNDATIONS
  end

  def by
    explanation = []
    if self.waivers.any?
      explanation << "waiving " + self.relevant_waivers.join(", ")
    end
    explanation << "enrolling in " + relevant_enrollments.join(", ")
    explanation.join(" and ")
  end

  def to_s
    "Foundations Constraint [#{FOUNDATIONS.join(",")}]"
  end
end