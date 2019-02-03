
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

#
# This works only if there are no nested values.
# Needs same schema
def mergedWithSumOfValues(hash_first, hash_second)
  result = {}
  hash_first.each do |key, value|
    # hash
    if value.is_a?(::Hash) && hash_second[key].is_a?(::Hash)
      result[key] = mergedWithSumOfValues(value, hash_second[key])
    elsif value.is_a?(::Hash)
      result[key] = value

    # common values
    elsif value.is_a?(Numeric) && hash_second[key].is_a?(Numeric)
      result[key] = value + hash_second[key]
    elsif hash_first[key].is_a?(Numeric)
      result[key] = value
    end
  end

  hash_second.each do |key, value|
    # checked common items above.
    if value.is_a?(::Hash) && !hash_first[key].is_a?(::Hash)
      result[key] = value

      # next values
    elsif value.is_a?(Numeric) && !hash_first[key].is_a?(Numeric)
      result[key] = value
    end
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