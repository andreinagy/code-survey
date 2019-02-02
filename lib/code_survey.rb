require 'json'

require 'code_survey/version'
require 'code_survey/arguments_parser.rb'
require 'code_survey/shell_adapter.rb'
require 'code_survey/helpers.rb'

module Main
  def self.executable_hash(options)
    {
      'date' => options.scan_date,
      'anonymized' => options.anonymize,
      'directory' => options.input_directory,
      'ignore' => options.ignore_list
    }
  end
  private_class_method :executable_hash

  def self.main(argv)
    options = Parser.parse(argv)
    result = {
      EXECUTABLE_NAME => executable_hash(options),
      'languages' => [
        {
          'name' => 'swift',
          'files' => '200 bla',
          'keywordsTypes' => 'bla',
          'keywordsFunctions' => 'bla',
          'keywordsComplexity' => 'bla',
          'keywordsPositive' => 'bla',
          'keywordsNegative' => 'bla'
        },
        {
          'name' => 'java',
          'files' => '200 bla',
          'keywordsTypes' => 'bla',
          'keywordsFunctions' => 'bla',
          'keywordsComplexity' => 'bla',
          'keywordsPositive' => 'bla',
          'keywordsNegative' => 'bla'
        }
      ]
    }

    puts JSON.pretty_generate(result)

    exit 0
  end
end
