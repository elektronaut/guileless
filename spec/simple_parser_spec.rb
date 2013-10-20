require 'spec_helper'

describe SimpleParser do
  let(:parser) { SimpleParser }

  describe ".parse" do
    it "allows comments" do
      parser.parse("foo <!-- <b>comment</b> --> bar").should == "<p>foo <!-- <b>comment</b> --> bar</p>"
    end

    it "doesn't wrap comments" do
      parser.parse("<!-- <b>comment</b> -->").should == "<!-- <b>comment</b> -->"
    end

    it "doesn't wrap empty block tags" do
      parser.parse("<div></div>").should == "<div></div>"
    end

    it "ignores empty tags" do
      parser.parse("<b></b>").should == "<b></b>"
    end

    it "converts single breaks to <br>" do
      parser.parse("foo\nbar").should == "<p>foo<br>bar</p>"
    end

    it "converts double breaks to <br>" do
      parser.parse("foo\n\nbar").should == "<p>foo</p><p>bar</p>"
    end

    it "escapes left angled brackets" do
      parser.parse("<").should == "<p>&lt;</p>"
    end

    it "escapes right angled brackets" do
      parser.parse(">").should == "<p>&gt;</p>"
    end

    it "escapes ampersands" do
      parser.parse("&").should == "<p>&amp;</p>"
    end

    it "doesn't escape already escaped ampersands" do
      parser.parse("&amp;").should == "<p>&amp;</p>"
    end

    it "understands empty attributes" do
      parser.parse("<blockquote data-foo>stuff</blockquote>").should == "<blockquote data-foo><p>stuff</p></blockquote>"
    end

    it "understands single quoted attributes" do
      parser.parse("<blockquote data-foo='bar'>stuff</blockquote>").should == "<blockquote data-foo='bar'><p>stuff</p></blockquote>"
    end

    it "understands double quoted attributes" do
      parser.parse("<blockquote data-foo=\"bar\">stuff</blockquote>").should == "<blockquote data-foo=\"bar\"><p>stuff</p></blockquote>"
    end

    it "ignores non-closed tags" do
      parser.parse("<blockquote><b>stuff</blockquote>").should == "<blockquote><p><b>stuff</p></blockquote>"
    end

    it "nests tags properly" do
      parser.parse("foo<blockquote>bar</blockquote>baz").should == "<p>foo</p><blockquote><p>bar</p></blockquote><p>baz</p>"
    end

    it "doesn't wrap existing paragraphs" do
      parser.parse("<p>foo</p>").should == "<p>foo</p>"
    end
  end
end