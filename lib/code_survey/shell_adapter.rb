require 'find'
require_relative 'languages/swift'
require_relative 'helpers.rb'

class ShellAdapter
  def self.analyze(options)
    language = FilesParser.new(options.ignore_list,
                               options.input_directory)

    [SWIFT_LANGUAGE].map do |x|
      language.analyze(x)
    end
      end
end

EMPTY_LINE = /\A\s*\Z/

class FilesParser
  def initialize(ignore_list, input_directory)
    @ignore_list = ignore_list
    @input_directory = input_directory
  end

  def analyze(language)
    string = ".*\.#{language[:file_extension]}$"
    extension = Regexp.new(string).freeze
    parse_files(find_files(@ignore_list, @input_directory, extension), language)
  end

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

  def parse_files(files, language)
    result = {
      'language_file_extension' => language[:file_extension],
      'files' => files.count || 0
    }

    files.each do |file|
      partial = parse_file(file, language)
      result = mergedWithSumOfValues(result, partial)
    end
    result
  end

  def occurences(lines, keywords)
    hashes = lines.map do |line|
      occurences_hash(line, keywords)
    end
    # puts '-----start-------'
    # puts hashes
    # result = hashes.inject { |memo, el| memo.merge(el) { |_k, old_v, new_v| old_v + new_v } }
    result = {}
    hashes.each do |partial|
      result = mergedWithSumOfValues(result, partial)
    end
    puts result
    puts '--------'
    result
  end

  # nandrei how to break this up?
  def parse_file(file, language)
    comment_level = 0 # process comments in comments too, why not?

    lines_comment = [] # Lines that contain comments. Empty or not. Closing comment line is not handled as code further.
    lines_empty = [] # Empty lines that are not included in comments.
    lines_code = [] # All lines that are not empty and not included in comments.

    comment_single = Regexp.new(language[:comments][:line_single]).freeze
    comment_start = Regexp.new(language[:comments][:line_multi][:start]).freeze
    comment_end = Regexp.new(language[:comments][:line_multi][:end]).freeze # this would crash for single line only languages?

    File.open(file).each do |line|
      if line =~ EMPTY_LINE
        lines_empty.push(line)
        next
      end

      if line =~ comment_start
        comment_level += 1
        lines_comment.push(line)
        next
      end

      if line =~ comment_end
        comment_level -= 1
        lines_comment.push(line)
        next
      end

      if comment_level > 0
        lines_comment.push(line)
        next
      end

      if line =~ comment_single
        lines_comment.push(line)
        next
      end

      lines_code.push(line)
    end

    {
      'linesOfCode' => lines_code.count,
      'linesOfComments' => lines_comment.count,
      'lines_empty' => lines_empty.count,
      'keywords' => occurences(lines_code, language[:keywords])
    }
  end
end
