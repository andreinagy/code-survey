require 'find'
require_relative 'languages/swift'
require_relative 'languages/objc'
require_relative 'helpers.rb'
require_relative 'file_parser.rb'

class ShellAdapter
  def self.analyze(options)
    file_parser = FilesParser.new(options.ignore_regex_string,
                                  options.input_directory)

    [
      SWIFT_LANGUAGE,
      OBJC_LANGUAGE
    ].map do |x|
      file_parser.analyze(x)
    end
      .compact
  end
end


