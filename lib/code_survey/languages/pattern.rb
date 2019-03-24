

class Pattern
  attr_accessor :key, :regex_string, :triggering_examples, :non_trigerring_examples

  def initialize(key, regex_string, description, triggering_examples, non_trigerring_examples)
    @key = key
    @regex = Regexp.new(regex_string)
    @description = description
    @triggering_examples = triggering_examples
    @non_trigerring_examples = non_trigerring_examples
  end

  def matches(line)
    line =~ @regex ? true : false
  end
end
