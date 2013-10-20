require "guileless/input_stream"
require "guileless/output_buffer"
require "guileless/parse_methods"
require "guileless/state_machine"
require "guileless/tag_library"
require "guileless/parser"
require "guileless/version"

module Guileless
  class << self
    def format(str)
      Parser.new(str).to_html
    end
  end
end
