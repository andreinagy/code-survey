EXECUTABLE_NAME = 'code-survey'.freeze

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
    result[category] = {:regexes => partial} unless partial.empty?
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
  puts "add totals"
  hash
end

def per_thousand_lines_of_code(hash)
  puts "per thousand lines"
  hash
end

# Tab separated output

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