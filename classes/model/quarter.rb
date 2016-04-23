class Quarter
  vattr_initialize :year, :season

  def to_s
    "#{season.to_s.capitalize} #{year.to_s}"
  end
end