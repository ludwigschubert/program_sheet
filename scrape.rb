require 'json'
require 'mechanize'
require 'mongo'
require 'nokogiri'
require 'thread'
require 'yaml'

EXPLORECOURSES_URL = 'http://explorecourses.stanford.edu/print?page=0&q=%25&catalog=&filter-coursestatus-Active=on&descriptions=on&collapse=&academicYear=&catalog='

def getMechanizeInstance()
    m = Mechanize.new
    m.user_agent = 'Mac Safari'
    return m
end

def getCourses(m, courses_array)
    source = Nokogiri::HTML(m.get(EXPLORECOURSES_URL).body)
    courses = source.css("div.searchResult")
    courses.each do |course|
        c = Hash.new
        number = course.at_css("span.courseNumber")
        unless number.nil?
            c["number"] = number.content.chomp(':')
        end
        title = course.at_css("span.courseTitle")
        unless title.nil?
            c["title"] = title.content
        end
        description = course.at_css("div.courseDescription")
        unless description.nil?
            c["description"] = description.content
        end
        attributes = course.at_css("div.courseAttributes")
        unless attributes.nil?
            data = attributes.content.strip()
            data = data.gsub(/\r\n/m, "")
            data_items = data.split('|')
            attributes_hash = Hash.new
            for data_item in data_items
                data_item_details = data_item.strip().split(/[:,]/)
                key = data_item_details[0].downcase
                if key == "units"
                    data = Hash.new
                    units_bounds = data_item_details[1].split("-")
                    data["lower"] = units_bounds[0].strip().to_i
                    data["upper"] = units_bounds[units_bounds.length - 1].strip().to_i
                    attributes_hash[key] = data
                elsif key == "grading"
                    grading_types = data_item_details[1].split("or")
                    data = Array.new
                    grading_types.each do |grading_type|
                        data << grading_type.strip()
                    end
                    attributes_hash[key] = data
                else
                    data = Array.new
                    for i in 1..(data_item_details.length - 1)
                        data << data_item_details[i].strip()
                    end
                    attributes_hash[key] = data
                end
            end
            c["attributes"] = attributes_hash
        end
        instructors = Array.new
        instructors_data = course.css(".courseAttributes a")
        instructors_data.each do |instructor_data|
            instructors << instructor_data.content
        end
        c["instructors"] = instructors
        courses_array << c
    end
end

# Generate thread pool that pulls items off the queue
m = getMechanizeInstance()
courses = []
getCourses(m, courses)
File.open("courses_dump.yml", "w") do |file|
    file << YAML::dump(courses)
end
