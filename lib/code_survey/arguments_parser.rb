require 'optparse'
require 'time'
require_relative 'helpers'

# https://docs.ruby-lang.org/en/2.1.0/OptionParser.html
Options = Struct.new(:anonymize,
                     :ignore_list,
                     :scan_date,
                     :input_directory)

# Parses the command line arguments
class Parser
  def self.default_options
    result = Options.new
    result.anonymize = false
    result.scan_date = Time.now.iso8601(3)
    result.input_directory = '.'
    result
  end
  private_class_method :default_options

  def self.parse(argv)
    # if no arguments, print help
    argv << '-h' if argv.empty?

    result = default_options

    options_parser = OptionParser.new do |o|
      o.banner = "Usage: #{EXECUTABLE_NAME} [options] [input directory]"

      o.on('-h',
           '--help',
           'Prints this help') do
        puts options_parser
        exit 0
      end

      o.on('-a',
           '--anonymize',
           "Anonymizes the output (#{result.anonymize})") do |v|
        result.anonymize = v
      end

      o.on('-tTODAY',
           '--today=TODAY',
           "Today's date for testing purposes (string)") do |v|
        result.scan_date = v
      end

      o.on('-i',
           '--ignore x,y,z',
           Array,
           'Ignore files that contain text in path (Eg. Cocoapods, test)') do |list|
        result.ignore_list = list
      end
    end

    begin
      options_parser.parse!(argv)
    rescue StandardError => exception
      puts exception
      puts options_parser
      exit 1
    end

    result.input_directory = argv.pop
    if result.input_directory.nil? || !Dir.exist?(result.input_directory)
      puts 'Can\'t find directory '
      Parser.parse %w[--help]
      exit 1
    end

    result
  end
end
