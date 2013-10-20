require_relative "guileless/input_stream"
require_relative "guileless/output_buffer"
require_relative "guileless/parse_methods"
require_relative "guileless/state_machine"
require_relative "guileless/tag_library"
require_relative "guileless/parser"

module Guileless
  class << self
    def parse(str)
      Parser.new(str).to_html
    end
  end
end
