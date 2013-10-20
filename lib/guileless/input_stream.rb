module Guileless
  class InputStream
    def initialize(input)
      @buffer = input.chars.to_a
    end

    def reinject(char)
      @buffer.unshift(char)
    end

    def empty?
      @buffer.length == 0
    end

    def fetch
      @buffer.shift
    end

    def discard(count=1)
      count.times { @buffer.shift }
    end

    def strip_whitespace
      @buffer.shift while @buffer.first == "\n"
    end

    def peek?(patterns)
      match = false
      Array(patterns).each do |pattern|
        if pattern.kind_of?(Regexp)
          match = true if self.to_s =~ pattern
        elsif pattern.kind_of?(String)
          match = true if self.to_s[0...(pattern.length)] == pattern
        end
      end
      match
    end

    def to_s
      @buffer.join
    end
  end
end