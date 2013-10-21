module Guileless
  module ParseMethods

    def escape_ampersand
      value = stream.peek?(/[\w\d]+;/) ? "&" : "&amp;"
      @char_count += value.length
      value
    end

    def start_tag
      if stream.peek?(block_level_tags) || stream.peek?(closing(block_level_tags))
        flush_buffer
      end
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

    def parse_tag_name(char, next_state=:tag)
      case
      when char =~ /\w/
        @tag_name += char
        char
      else
        stream.reinject char
        [false, next_state]
      end
    end

    def parse_closing_tag_name(char)
      parse_tag_name(char, :closing_tag)
    end

    def parse_left_angled_quote(char)
      case

      # Comment
      when stream.peek?("!--")
        stream.discard(3)
        ["<!--", :comment]

      # Opening tag
      when stream.peek?(html_tags)
        start_tag
        [char, :tag_name]

      # Closing tag
      when stream.peek?(closing(html_tags))
        start_tag
        stream.discard
        ["</", :closing_tag_name]

      # Escape left angled bracket
      else
        @char_count += 4
        "&lt;"
      end
    end

    def parse_linebreak
      if stream.peek?("\n")
        flush_buffer
        stream.strip_whitespace
        false
      else
        "<br>"
      end
    end

    def parse_text(char)
      case

      # Comment
      when char == "<"
        parse_left_angled_quote(char)

      # Escape right angled bracket
      when char == ">"
        @char_count += 4
        "&gt;"

      # Escape ampersands
      when char == "&"
        escape_ampersand

      # Line break
      when char == "\n"
        parse_linebreak

      when char !=~ /\s/
        @char_count += 1
        char

      end
    end

  end
end