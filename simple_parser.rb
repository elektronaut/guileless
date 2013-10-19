require_relative "simple_parser/input_stream"
require_relative "simple_parser/output_buffer"
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

target = "<!-- comment --><p>&gt;_&lt;3 foo</p><div><blockquote foo=\"bar\" bar='single' baz><p>in</p><p> a<br><span><img src=\"a.png\" >quote</span></p><p>yeah</p></blockquote></div><p>next line</p>"

str = "<!-- comment -->\n\n>_<3 foo\n\n\n<div><blockquote foo=\"bar\" bar='single' baz>in\n\n a\n<span><img src=\"a.png\" >quote</span>\n\nyeah</blockquote></div>next line"
puts SimpleParser.parse(str).inspect
puts str.inspect

raise "Wrong!" unless target == SimpleParser.parse(str)
