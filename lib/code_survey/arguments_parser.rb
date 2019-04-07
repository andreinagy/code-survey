require 'optparse'
require 'time'
require_relative 'helpers'

# https://docs.ruby-lang.org/en/2.1.0/OptionParser.html
Options = Struct.new(
                     :ignore_regex_string,
                     :scan_date,
                     :json_output,
                     :per_thousand_lines_of_code,
                     :input_directory)

# Parses the command line arguments
class Parser
  def self.default_options
    result = Options.new
    result.scan_date = Time.now.iso8601(3)
    result.json_output = false
    result.per_thousand_lines_of_code = false
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

      o.on('-tTODAY',
           '--today=TODAY',
           "Today's date for testing purposes (string)") do |v|
        result.scan_date = v
      end

      o.on('-iIGNORE',
           '--ignore-regex=IGNORE',
           'Case sensitive ignore files regex. Eg. "Ignore|Debug"') do |v|
        result.ignore_regex_string = v
      end

      o.on("--json", "Output in JSON format") do |v|
        result.json_output = v
      end

      o.on("--per-thoudsand-lines", "Output counts/1000 lines of code") do |v|
        result.per_thousand_lines_of_code = v
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
