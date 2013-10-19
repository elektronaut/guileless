module SimpleParser
  class Parser
    include SimpleParser::StateMachine
    include SimpleParser::TagLibrary

    attr_accessor :input, :stream, :tag_stack, :buffer, :tag_name

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

    def parse_attribute_name(char)
      case
      when char !=~ /[\w\-]/
        stream.reinject char
        [false, :tag]
      when char == "=" && stream.peek?("'")
        stream.discard
        ["='", :attribute_value_single_quote]
      when char == "=" && stream.peek?("\"")
        stream.discard
        ["=\"", :attribute_value_double_quote]
      when char == "="
        [char, :attribute_value]
      end
    end

    def parse_attribute_value(char)
      case
      when char !=~ /[\w\d]/
        stream.reinject char
        [false, :tag]
      end
    end

    def parse_attribute_value_single_quote(char)
      case
      when char == "'"
        [char, :tag]
      end
    end

    def parse_attribute_value_double_quote(char)
      case
      when char == "\""
        [char, :tag]
      end
    end

    def parse_comment(char)
      case
      when char == "-" && stream.peek?("->")
        stream.discard(2)
        ["-->", :text]
      end
    end

    def parse_tag(char)
      case
      when char =~ /\w/
        [char, :attribute_name]
      when char == ">"
        [char, :text]
      end
    end

    def parse_closing_tag(char)
      case
      when char == ">"
        [char, :text]
      end
    end

    def parse_tag_name(char)
      case
      when char =~ /\w/
        @tag_name += char
        char
      else
        stream.reinject char
        [false, :tag]
      end
    end

    def parse_closing_tag_name(char)
      case
      when char =~ /\w/
        @tag_name += char
        char
      else
        stream.reinject char
        [false, :closing_tag]
      end
    end

    def parse_left_angled_quote(char)
      case

      # Comment
      when stream.peek?("!--")
        stream.discard(3)
        ["<!--", :comment]

      # Opening tag
      when stream.peek?(html_tags)
        [char, :tag_name]

      # Closing block level tag
      when stream.peek?(closing(block_level_tags))
        flush_buffer
        stream.discard
        ["</", :closing_tag_name]

      # Closing tag
      when stream.peek?(closing(html_tags))
        stream.discard
        ["</", :closing_tag_name]

      # Escape left angled bracket
      else
        "&lt;"
      end
    end

    def parse_text(char)
      case

      # Comment
      when char == "<"
        parse_left_angled_quote(char)

      # Escape right angled bracket
      when char == ">"
        "&gt;"

      # Paragraph break
      when char == "\n" && stream.peek?("\n")
        flush_buffer
        stream.strip_whitespace
        false

      # Line break
      when char == "\n"
        "<br>"

      end
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