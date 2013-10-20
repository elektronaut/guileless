# Guileless [![Build Status](https://travis-ci.org/elektronaut/guileless.png)](https://travis-ci.org/elektronaut/guileless) [![Code Climate](https://codeclimate.com/github/elektronaut/guileless.png)](https://codeclimate.com/github/elektronaut/guileless)

Guileless is a naive HTML preprocessor. It does three things:

1. Single line breaks are converted to `<br>`
2. Several consecutive line breaks are treated as paragraphs and wrapped in `<p>`
3. Converts stray `<`, `>`, and `&`s to HTML entities.

Why is this more useful than, say, Rails' built in `simple_format`?

Well, it's actually a real (if simplistic) HTML parser. It understands nested
tags, and will happily format text nodes inside `div`s and `blockquote`s.

However, it does **NOT** do any sanitation on the input.

## Installation

    gem install guileless

or add it to your gemfile:

    gem "guileless"

## Usage

```ruby
Guileless.format("<div>foo</div>") # => "<div><p>foo</p></div>"
```

## License

Copyright (c) 2013 Inge Jørgensen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
