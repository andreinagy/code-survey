require 'json'

require 'code_survey/version'
require 'code_survey/arguments_parser.rb'
require 'code_survey/shell_adapter.rb'
require 'code_survey/helpers.rb'

module Main
  def self.executable_hash(options)
    {
      :date => options.scan_date,
      :json_output => options.json_output,
      :add_totals => options.add_totals, #nandrei needs implementation
      :per_thousand_lines_of_code => options.per_thousand_lines_of_code, #nandrei needs implementation
      :directory => options.input_directory,
      :ignore => options.ignore_regex_string
    }
  end
  private_class_method :executable_hash

  def self.main(argv)
    options = Parser.parse(argv)
    result = {
      EXECUTABLE_NAME => executable_hash(options),
      :languages => ShellAdapter.analyze(options)
    }

    result = hash_with_totals(result) if options.add_totals
    result = per_thousand_lines_of_code(result) if options.per_thousand_lines_of_code

    if options.json_output
      puts JSON.pretty_generate(result)
    else
      puts tab_separated_values(result)
    end

    exit 0
  end
end
