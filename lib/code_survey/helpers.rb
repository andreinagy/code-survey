
EXECUTABLE_NAME = 'code-survey'.freeze

def occurences_hash(line, keywords)
  result = {}
  keywords.map do |category, sub_hash|
    partial = {}
    sub_hash.map do |keyword, _regex|
      regexp = Regexp.new(keyword)
      value = line =~ regexp ? 1 : 0
      partial[keyword] = value unless value.zero?
    end
    result[category] = partial unless partial.empty?
  end
  result.empty? ? nil : result
end

def value(value, other_value)
  return value if other_value.nil?
  # nested hashes
  if value.is_a?(::Hash) && other_value.is_a?(::Hash)
    mergedWithSumOfValues(value, other_value)

  # numeric values
  elsif value.is_a?(Numeric) && other_value.is_a?(Numeric)
    value + other_value
  end
end

#
# This works only if there are no nested values.
# Needs same schema
def mergedWithSumOfValues(hash_first, hash_second)
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
    result = mergedWithSumOfValues(result, partial)
  end
  result.empty? ? nil : result
end
