require 'test_helper'
require_relative '../lib/code_survey/languages/pattern'

class PatternTest < Minitest::Test
  def self.make_default_pattern
    Pattern.new('key',
                'regex',
                'Matches lines containing regex',
                ['line contains regex'],
                ['line does not contain'])
  end

  def test_pattern_does_not_match
    pattern = self.class.make_default_pattern

    assert pattern.matches('line not matching expected somewhere') == false
  end

  def test_pattern_does_not_match
    pattern = self.class.make_default_pattern

    assert pattern.matches('line containing regex somewhere') == true
  end
end
