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

    if options.json_output
      puts JSON.pretty_generate(result)
    else
      puts tab_separated_values(result)
    end
    # --------------------------------------------------------------------------------
    # Language                      files          blank        comment           code
    # --------------------------------------------------------------------------------
    # Ruby                             20            149             98            675
    # Objective C                       1             27             11             86
    # Markdown                          2             38              0             79
    # Kotlin                            1             16             21             46
    # Swift                             3             19              5             30
    # C/C++ Header                      1              4              9              6
    # Bourne Again Shell                1              2              1              5
    # YAML                              1              0              0              5
    # Bourne Shell                      1              0              0              2
    # --------------------------------------------------------------------------------
    # SUM:                             31            255            145            934
    # --------------------------------------------------------------------------------

    # Language  files blank comment code  types functios  complexity  potentially_good potentially_neutral potentially_bad

    exit 0
  end
end

def tab_separated_values(hash)
  result = []
  result.push(tab_joined_header)

  totals_hash = make_empty_totals_hash

  hash[:languages].each do |language_hash|

    code_hash = {}
    language_hash[:keywords_code].each do |key, value|
      code_hash[key] = value[:total]
    end

    language_line_hash = {
      :name => language_hash[:name], 
      :files => language_hash[:files] || 0,
      :linesEmpty => language_hash[:linesEmpty] || 0,
      :linesOfComments => language_hash[:linesOfComments] || 0,
      :linesOfCode => language_hash[:linesOfCode] || 0,
      :types => code_hash[:types] || 0,
      :functions => code_hash[:functions] || 0,
      :complexity => code_hash[:complexity] || 0,
      :potentially_good => code_hash[:potentially_good] || 0,
      :potentially_neutral => code_hash[:potentially_neutral] || 0,
      :potentially_bad => code_hash[:potentially_bad] || 0
    }

      totals_hash = merged_hashes_numeric_sum(totals_hash, language_line_hash)
      totals_hash[:name] = 'total'

    result.push(tab_joined_hash(language_line_hash))
  end

  result.push(tab_joined_hash(totals_hash))

  result
end

def tab_joined_header()
  tab_joined_array(['Language', 
  'files', 
  'blank', 
  'comment', 
  'code',  
  'types', 
  'functions',  
  'complexity',  
  'potentially_good', 
  'potentially_neutral', 
  'potentially_bad'])
end

def make_empty_totals_hash()
  language_line_hash = {
    :name => 'total', 
    :files => 0,
    :linesEmpty => 0,
    :linesOfComments => 0,
    :linesOfCode => 0,
    :types => 0,
    :functions => 0,
    :complexity => 0,
    :potentially_good => 0,
    :potentially_neutral => 0,
    :potentially_bad => 0
  }
end

def tab_joined_hash(language_line_hash)
  tab_joined_array([
    language_line_hash[:name], 
    language_line_hash[:files],
    language_line_hash[:linesEmpty],
    language_line_hash[:linesOfComments],
    language_line_hash[:linesOfCode],
    language_line_hash[:types],
    language_line_hash[:functions],
    language_line_hash[:complexity],
    language_line_hash[:potentially_good],
    language_line_hash[:potentially_neutral],
    language_line_hash[:potentially_bad]])
end

def tab_joined_array(array)
  array.join("\t")
end
