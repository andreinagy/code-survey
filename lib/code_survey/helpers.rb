
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
    result[category] = partial unless partial.empty?
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
  
  # add total
  result.each do |key, value|
    section = result[key]
    section[:total] = section.inject(0) { |sum, tuple| sum += tuple[1] }
  end

  result.empty? ? nil : result
end