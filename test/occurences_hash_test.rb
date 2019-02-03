require 'test_helper'
require_relative '../lib/code_survey/helpers'

KEYWORDS = {
  'nouns' => [
    'Time Warp',
    'rabbit'
  ],
  'articles' => [
    'the'
  ]
}.freeze

class MergeHashesTest < Minitest::Test
  def test_no_match
    line = "I've got to keep control"

    result = occurences_hash(line, KEYWORDS)
    assert result.nil?
  end

  def test_simple_occurrences_hash
    line = "Let's do the Time Warp again"

    result = occurences_hash(line, KEYWORDS)
    assert result['nouns']['Time Warp'] == 1
    assert result['articles']['the'] == 1
  end

  def test_multiple_occurences_in_line_hash
    line = "I remember doing the Time Warp Let's do the Time Warp again"

    result = occurences_hash(line, KEYWORDS)

    # Not detecting right now.
    assert result['nouns']['Time Warp'] == 1
    assert result['articles']['the'] == 1
  end
end
