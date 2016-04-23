class Constraint
  attr_accessor :errors
  vattr_initialize :enrollments, :waivers, :options do
    self.errors = []
  end

  def satisfied?
    raise "This method has to be implemented in a concrete subclass of constraint."
  end

  def by
    "This method should be implemented in a concrete subclass of constraint."
  end
  
end