
EXECUTABLE_NAME = 'code-survey'.freeze

# Files

def find_files(ignore_list, base_path, extension)
  file_paths = []
  Find.find(base_path) do |path|
    ignore_matches = (ignore_list || []).select do |item|
      path.include? item
    end
    should_ignore = ignore_matches.any?

    file_paths << path if path =~ extension && !should_ignore
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
  result.empty? ? nil : result
end
