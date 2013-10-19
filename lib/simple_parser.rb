require_relative "simple_parser/input_stream"
require_relative "simple_parser/output_buffer"
require_relative "simple_parser/parse_methods"
require_relative "simple_parser/state_machine"
require_relative "simple_parser/tag_library"
require_relative "simple_parser/parser"

module SimpleParser
  class << self
    def parse(str)
      Parser.new(str).to_html
    end
  end
end
