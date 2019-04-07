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
    result = merged_hashes_numeric_sum(HASH1, HASH2)

    assert result['hash1_unique_non_numeric'] == 'value1'
    assert result['hash2_unique_non_numeric'] == 'value2'
  end

  def test_hashes_numeric_merging
    result = merged_hashes_numeric_sum(HASH1, HASH2)

    assert result['value1'] == 1
    assert result['value2'] == 2
    assert result['value3'] == 1
  end

  def test_hashes_nested_merging
    result = merged_hashes_numeric_sum(HASH1_NESTED, HASH2_NESTED)

    assert result['nested']['value1'] == 1
    assert result['nested']['value2'] == 2
    assert result['nested']['value1'] == 1
  end

  def test_hashes_nil_values
    hash1 = {'key1' => 1, 'key2' => 2}
    hash2 = {'key1' => 3}

    result = merged_hashes_numeric_sum(hash1, hash2)
    assert result['key1'] == 4
    assert result['key2'] == 2
  end

  def test_hashes_nil_values_reversed
    hash1 = {'key1' => 1, 'key2' => 2}
    hash2 = {'key1' => 3}

    result = merged_hashes_numeric_sum(hash2, hash1)
    assert result['key1'] == 4
    assert result['key2'] == 2
  end

  def test_merge_with_nil
    hash1 = {'key1' => 1, 'key2' => 2}
    result = merged_hashes_numeric_sum(hash1, nil)
    assert result['key1'] == 1
    assert result['key2'] == 2
  end

  def test_merge_with_empty
    hash1 = {'key1' => 1, 'key2' => 2}
    result = merged_hashes_numeric_sum(hash1, {})
    assert result['key1'] == 1
    assert result['key2'] == 2
  end
end
