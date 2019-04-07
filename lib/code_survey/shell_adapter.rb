require 'find'
require_relative 'helpers.rb'
require_relative 'file_parser.rb'

require_relative 'languages/swift'
require_relative 'languages/objc'
require_relative 'languages/ruby'
require_relative 'languages/kotlin'

class ShellAdapter
  def self.analyze(options)
    file_parser = FilesParser.new(options.ignore_regex_string,
                                  options.input_directory)

    [
      SWIFT_LANGUAGE,
      OBJC_LANGUAGE,
      KOTLIN_LANGUAGE,
      RUBY_LANGUAGE
    ].map do |x|
      file_parser.analyze(x)
    end
      .compact
  end
end
