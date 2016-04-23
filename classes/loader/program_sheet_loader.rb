class ProgramSheetLoader

  def self.load enrollments, waivers
    YAML::load(open('program_sheets.yml' )).map do |name, constraints|
        constraints = constraints.map do |constraint_hash|
          constraint_class = constraint_hash.delete 'name'
          Object::const_get(constraint_class).new enrollments, waivers, constraint_hash
        end
        ProgramSheet.new name, constraints
      end
  end

end