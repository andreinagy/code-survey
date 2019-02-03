require 'test_helper'
require_relative '../lib/code_survey/helpers'

HASH1 = {
  'hash1_unique_non_numeric' => 'value1',
  'value1' => 1,
  'value2' => 1
}.freeze
HASH2 = {
  'hash2_unique_non_numeric' => 'value2',
  'value2' => 1,
  'value3' => 1
}.freeze
HASH1_NESTED = {
  'nested' => {
    'value1' => 1,
    'value2' => 1
  }
}.freeze
HASH2_NESTED = {
  'nested' => {
    'value2' => 1,
    'value3' => 1
  }
}.freeze

class MergeHashesTest < Minitest::Test
  def test_hashes_strings_merging
    result = mergedWithSumOfValues(HASH1, HASH2)

    assert result['hash1_unique_non_numeric'] == 'value1'
    assert result['hash2_unique_non_numeric'] == 'value2'
  end

  def test_hashes_numeric_merging
    result = mergedWithSumOfValues(HASH1, HASH2)

    assert result['value1'] == 1
    assert result['value2'] == 2
    assert result['value3'] == 1
  end

  def test_hashes_nested_merging
    result = mergedWithSumOfValues(HASH1_NESTED, HASH2_NESTED)

    assert result['nested']['value1'] == 1
    assert result['nested']['value2'] == 2
    assert result['nested']['value1'] == 1
  end
end
