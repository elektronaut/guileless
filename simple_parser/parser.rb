module SimpleParser
  class Parser < SimpleParser::StateMachine
    include SimpleParser::TagLibrary
    include SimpleParser::ParseMethods

    attr_reader :input, :stream, :tag_stack, :buffer, :tag_name

    before_transition :reset_tag_name,   [:tag_name, :closing_tag_name]
    before_transition :add_tag_to_stack, :text, from: [:tag]
    before_transition :close_tag,        :text, from: [:closing_tag]
    before_transition :finish_tag,       :text, from: [:tag, :closing_tag]
    before_transition :flush_buffer,     :text, from: [:comment]
    before_transition :flush_buffer,     :end

    def initialize(input)
      @input = input
    end

    def to_html
      parse!
      buffer.to_s
    end

    def parse!
      reset!
      read while !stream.empty?
      transition(:end)
    end

    def read
      char = stream.fetch
      value, next_state = Array(self.send("parse_#{state}".to_sym, char))

      if value === nil
        buffer.add char
      elsif value
        buffer.add value
      end

      transition(next_state) if next_state
    end

    def flush_buffer
      if buffer.buffered? && state == :text
        buffer.wrap("<p>", "</p>")
      end
      buffer.flush
    end

    def finish_tag
      if block_level_tags.include?(tag_name)
        flush_buffer
      end
    end

    def add_tag_to_stack
      @tag_stack << tag_name
    end

    def close_tag
      unwind_tag_stack(tag_name)
    end

    def unwind_tag_stack(tag)
      if tag_stack.include?(tag)
        last_tag = tag_stack.pop while last_tag != tag
      end
    end

    def reset_tag_name
      @tag_name = ""
    end

    def reset!
      @buffer = SimpleParser::OutputBuffer.new
      @stream = SimpleParser::InputStream.new(input)
      @tag_stack = []
      reset_tag_name
      @state = :text
    end
  end
end