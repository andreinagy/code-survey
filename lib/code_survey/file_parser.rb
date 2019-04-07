EMPTY_LINE = /\A\s*\Z/

class FilesParser
  def initialize(ignore_regex_string, input_directory)
    @ignore_regex_string = ignore_regex_string
    @input_directory = input_directory
  end

  def analyze(language)
    extension = Regexp.new(".#{language[:file_extension]}$").freeze
    parse_files(find_files(@ignore_regex_string, @input_directory, extension), language)
  end

  def parse_files(files, language)
    return nil if files.empty?

    result = {
      'name' => language[:name],
      'fileExtension' => language[:file_extension],
      'files' => files.count || 0
    }

    files.each do |file|
      partial = parse_file(file, language)
      result = merged_hashes_numeric_sum(result, partial)
    end
    result
  end

  # nandrei how to break this up?
  def parse_file(file, language)
    comment_level = 0 # process comments in comments too, why not?

    # Lines that contain comments. Empty or not. Closing comment line is not handled as code further.
    lines_comment = []

    # Empty lines that are not included in comments.
    lines_empty = []

    # All lines that are not empty and not included in comments.
    lines_code = []

    comment_single = Regexp.new(language[:comments][:line_single]).freeze
    comment_start = Regexp.new(language[:comments][:line_multi][:start]).freeze

    # this would crash for single line only languages?
    comment_end = Regexp.new(language[:comments][:line_multi][:end]).freeze

    # puts file
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

    result = {
      'linesOfCode' => lines_code.count,
      'linesOfComments' => lines_comment.count,
      'linesEmpty' => lines_empty.count
    }
    comments = all_occurences_hash(lines_comment,
                                   language[:keywords_comments])
        result['keywords_comments'] = comments unless comments.nil?

    code = all_occurences_hash(lines_code,
                               language[:keywords_code])
    result['keywords_code'] = code unless code.nil?

    result
  end
end