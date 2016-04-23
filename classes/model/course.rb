class Course
  vattr_initialize :code, :seasons, :unit_range

  def to_s
    "#{code} (Held in #{seasons.join(',')}; #{unit_range.to_a.join(',')} units)"
  end

end