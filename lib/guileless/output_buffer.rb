module Guileless
  class OutputBuffer
    def initialize
      @output_buffer = []
      @output = []
    end

    def add(str)
      str = str.chars.to_a if str.kind_of?(String)
      @output_buffer += Array(str)
      str
    end

    def buffered?
      @output_buffer.length > 0
    end

    def flush
      @output += @output_buffer
      @output_buffer = []
    end

    def wrap(prefix, postfix)
      prefix = prefix.chars.to_a if prefix.kind_of?(String)
      postfix = postfix.chars.to_a if postfix.kind_of?(String)
      @output_buffer = Array(prefix) + @output_buffer + Array(postfix)
    end

    def to_s
      @output.join
    end
  end
end