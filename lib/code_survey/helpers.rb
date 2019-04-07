EXECUTABLE_NAME = 'code-survey'.freeze
TOTAL = 'total'.freeze
TAB = "\t".freeze

# Files

def find_files(ignore_regex_string, base_path, extension)
  file_paths = []
  ignore_regex = Regexp.new(ignore_regex_string) unless ignore_regex_string.nil?
  Find.find(base_path) do |path|
    next if File.directory? path
    next if path !~ extension

    if ignore_regex
      next if path =~ ignore_regex
    end

    file_paths << path
  end
  file_paths
end

# Find occurences in strings and hashes

def regexp_value(line, keyword)
  regexp = Regexp.new(keyword)
  value = line =~ regexp ? 1 : 0
  value > 0 ? value : nil
end

def occurences_hash(line, keywords)
  result = {}
  keywords.map do |category, sub_hash|
    partial = {}
    sub_hash.map do |keyword, _regex|
      value = regexp_value(line, keyword)
      partial[keyword] = value unless value.nil?
    end
    result[category] = { regexes: partial } unless partial.empty?
  end
  result.empty? ? nil : result
end

def value(value, other_value)
  return value if other_value.nil?

  # nested hashes
  if value.is_a?(::Hash) && other_value.is_a?(::Hash)
    merged_hashes_numeric_sum(value, other_value)

  # numeric values
  elsif value.is_a?(Numeric) && other_value.is_a?(Numeric)
    value + other_value
  end
end

#
# This works only if there are no nested values.
# Needs same schema
def merged_hashes_numeric_sum(hash_first, hash_second)
  result = {}
  return hash_first if hash_second.nil?
  return hash_second if hash_first.nil?

  hash_first.each do |key, value|
    other_value = hash_second[key]
    result[key] = value(value, other_value)
  end

  hash_second.each do |key, value|
    other_value = hash_first[key]
    result[key] = value(value, other_value)
  end
  result.empty? ? nil : result
end

def all_occurences_hash(lines, keywords)
  hashes = lines.map do |line|
    occurences_hash(line, keywords)
  end
  result = {}
  hashes.compact.each do |partial|
    result = merged_hashes_numeric_sum(result, partial)
  end

  result.each do |key, _value|
    section = result[key]
    section[:total] = section[:regexes].inject(0) { |sum, tuple| sum += tuple[1] }
  end

  result.empty? ? nil : result
end

def hash_with_totals(hash)
  totals_hash = make_empty_totals_hash

  hash[:languages].each do |language_hash|
    line_hash = language_line_hash(language_hash)
    totals_hash = by_adding_language_line(totals_hash, line_hash)
  end

  hash[:total] = totals_hash
  hash
end

def per_thousand_lines_of_code(hash)
  mutated_hash = {}
  mutated_hash[:languages] = []

  hash[:languages].each do |language_hash|
    thousands_lines = language_hash[:linesOfCode] / 1000.0

    new_hash = recursively_divide_hash_numbers(language_hash, thousands_lines)
    new_hash[:linesOfCode] = thousands_lines
    mutated_hash[:languages] << new_hash

  end
  hash[:languages] = mutated_hash[:languages]

  unless hash[:total].nil?
    totals_hash = hash[:total]
    thousands_lines = totals_hash[:linesOfCode] / 1000.0

    new_hash = recursively_divide_hash_numbers(totals_hash, thousands_lines)
    new_hash[:linesOfCode] = thousands_lines
    mutated_hash[:total] = new_hash
  end
  hash[:total] = mutated_hash[:total]

  hash
end

def recursively_divide_hash_numbers(hash, thousands_lines)
  result = {}
  hash.each do |key, value|
    if value.class == Fixnum
      result[key] = value / thousands_lines
      next
    end

    if value.class == Hash
      result[key] = recursively_divide_hash_numbers(value, thousands_lines)
      next
    end
    result[key] = value
  end
  result
end

# Tab separated output

def tab_separated_values(hash)
  result = []
  result.push(tab_joined_header)
  hash[:languages].each do |language_hash|
    line_hash = language_line_hash(language_hash)
    result.push(tab_joined_hash(line_hash))
  end

  unless hash[:total].nil?
    puts hash[:total]
    line_hash = language_line_hash(hash[:total])
    result.push(tab_joined_hash(line_hash))
  end

  result
end

# can be totals or language hash.
def language_line_hash(language_hash)
  code_hash = {}

  unless language_hash[:keywords_code].nil?
    language_hash[:keywords_code].each do |key, value|
      code_hash[key] = value[:total]
    end
  end

  {
    name: language_hash[:name],
    files: language_hash[:files] || 0,
    linesEmpty: language_hash[:linesEmpty] || 0,
    linesOfComments: language_hash[:linesOfComments] || 0,
    linesOfCode: language_hash[:linesOfCode] || 0,
    types: language_hash[:types] || code_hash[:types] || 0,
    functions: language_hash[:functions] || code_hash[:functions] || 0,
    complexity: language_hash[:complexity] || code_hash[:complexity] || 0,
    potentially_good: language_hash[:potentially_good] || code_hash[:potentially_good] || 0,
    potentially_neutral: language_hash[:potentially_neutral] || code_hash[:potentially_neutral] || 0,
    potentially_bad: language_hash[:potentially_bad] || code_hash[:potentially_bad] || 0
  }
end

def by_adding_language_line(total_hash, language_line_hash)
  {
    name: total_hash[:name],
    files: total_hash[:files] + language_line_hash[:files] || 0,
    linesEmpty: total_hash[:linesEmpty] + language_line_hash[:linesEmpty] || 0,
    linesOfComments: total_hash[:linesOfComments] + language_line_hash[:linesOfComments] || 0,
    linesOfCode: total_hash[:linesOfCode] + language_line_hash[:linesOfCode] || 0,
    functions: total_hash[:functions] + language_line_hash[:functions] || 0,
    complexity: total_hash[:complexity] + language_line_hash[:complexity] || 0,
    potentially_good: total_hash[:potentially_good] + language_line_hash[:potentially_good] || 0,
    potentially_neutral: total_hash[:potentially_neutral] + language_line_hash[:potentially_neutral] || 0,
    potentially_bad: total_hash[:potentially_bad] + language_line_hash[:potentially_bad] || 0
  }
end

def tab_joined_header
  tabs_joined_string(%w[Language
                        Files
                        Lines_blank
                        Lines_comments
                        Lines_code
                        Types
                        Functions
                        Complexity
                        Potentially_good
                        Potentially_neutral
                        Potentially_bad])
end

def make_empty_totals_hash
  language_line_hash = {
    name: TOTAL,
    files: 0,
    linesEmpty: 0,
    linesOfComments: 0,
    linesOfCode: 0,
    types: 0,
    functions: 0,
    complexity: 0,
    potentially_good: 0,
    potentially_neutral: 0,
    potentially_bad: 0
  }
end

def tab_joined_hash(language_line_hash)
  tabs_joined_string([
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
                       language_line_hash[:potentially_bad]
                     ])
end

def tabs_joined_string(array)
  array.join(TAB)
end
