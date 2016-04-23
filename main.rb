require 'attr_extras'
require 'colorize'
require 'yaml'

Dir[File.join(__dir__, 'classes', '**', '*.rb')].each {|file| require file }

courses = CourseDumpLoader.load
enrollments = YAML::load(open('enrollments.yml' ))

enroller = Enroller.new enrollments, courses
enrollments = enroller.enrollments
waivers = enroller.waivers

program_sheets = ProgramSheetLoader.load enrollments, waivers

satisfactions = []
program_sheets.each do |program_sheet|
  puts "Specialization " + program_sheet.name.bold.blue

  errors = []
  program_sheet.constraints.each do |constraint|
    if constraint.satisfied?
      satisfactions << "Satisfied #{constraint} via #{constraint.by}".light_white
    else
      errors += constraint.errors
    end
  end

  if errors.empty?
    puts "Looks good!"
  else
    puts "There are #{errors.length} issues:".red
    puts errors.join("\n")
  end

  puts "\n"
end

puts "Enrollments:".underline
enrollments.group_by(&:quarter).each do |quarter, enrollments_in_quarter|
  puts "#{quarter}:".bold.green
  puts enrollments_in_quarter
end

puts ""

puts "Waivers:".underline
puts waivers.join(", ").green

puts ""
puts satisfactions


