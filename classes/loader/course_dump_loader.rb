class CourseDumpLoader

  def self.load
    YAML::load(open('courses_dump.yml' )).map do |raw_course|
        code = raw_course['number']
        seasons = if raw_course['attributes']['terms']
          raw_course['attributes']['terms'].map do |term_string|
            case term_string
            when "Aut"
              'fall'
            when "Win"
              'winter'
            when "Spr"
              'spring'
            when "Sum"
              'summer'
            else
              'weird'
            end
          end
        else
          ['weird']
        end
        unit_range = Range.new raw_course['attributes']['units']['lower'], raw_course['attributes']['units']['upper']
        Course.new code, seasons, unit_range
      end
  end

end