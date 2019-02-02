require 'find'
require_relative 'languages/swift'

class ShellAdapter
  def self.analyze(options)
    language = FilesParser.new(options.ignore_list,
                               options.input_directory)

    [SWIFT_LANGUAGE].map do |x|
      language.analyze(x)
    end
      end
end

REGEX = /.*\.swift$/

class FilesParser
  def initialize(ignore_list, input_directory)
    @ignore_list = ignore_list
    @input_directory = input_directory
  end

  def analyze(language)
    parse_files(find_files(@ignore_list, @input_directory), language)
  end

  def find_files(ignore_list, base_path)
    file_paths = []
    Find.find(base_path) do |path|
      ignore_matches = ignore_list.select do |item|
        path.include? item
      end
      should_ignore = ignore_matches.any?

      file_paths << path if path =~ REGEX && !should_ignore
    end
    file_paths
  end

  def parse_files(files, language)
    result = {
      'language_file_extension' => language[:file_extension],
      'files' => files.count || 0
    }
    keys = %w[linesOfCode
              linesOfComments
              linesEmpty
              keywordsTypes
              keywordsFunctions
              keywordsComplexity
              keywordsPositive
              keywordsNegative]

    keys.each do |key|
      result[key] = 0
    end

    files.each do |file|
      partial = parse_file(file)
      keys.each do |key|
        result[key] += partial[key] || 0
      end
    end
    result
  end

  def parse_file(file)
    puts "parse file #{file}"
    {
      'linesOfCode' => 3,
      'linesOfComments' => 1,
      'emptyLines' => 2,
      'keywordsTypes' => 1,
      'keywordsFunctions' => 1,
      'keywordsComplexity' => 1,
      'keywordsPositive' => 1,
      'keywordsNegative' => 1
    }
  end
end
