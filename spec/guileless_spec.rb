require 'spec_helper'

describe Guileless do
  describe ".format" do
    it "allows comments" do
      Guileless.format("foo <!-- <b>comment</b> --> bar").should == "<p>foo <!-- <b>comment</b> --> bar</p>"
    end

    it "doesn't wrap comments" do
      Guileless.format("<!-- <b>comment</b> -->").should == "<!-- <b>comment</b> -->"
    end

    it "doesn't wrap empty block tags" do
      Guileless.format("<div></div>").should == "<div></div>"
    end

    it "ignores empty tags" do
      Guileless.format("<b></b>").should == "<b></b>"
    end

    it "converts single breaks to <br>" do
      Guileless.format("foo\nbar").should == "<p>foo<br>bar</p>"
      Guileless.format("foo\r\nbar").should == "<p>foo<br>bar</p>"
    end

    it "converts double breaks to <br>" do
      Guileless.format("foo\n\nbar").should == "<p>foo</p><p>bar</p>"
      Guileless.format("foo\r\n\r\nbar").should == "<p>foo</p><p>bar</p>"
    end

    it "escapes left angled brackets" do
      Guileless.format("<").should == "<p>&lt;</p>"
    end

    it "escapes right angled brackets" do
      Guileless.format(">").should == "<p>&gt;</p>"
    end

    it "escapes ampersands" do
      Guileless.format("&").should == "<p>&amp;</p>"
    end

    it "doesn't escape already escaped ampersands" do
      Guileless.format("&amp;").should == "<p>&amp;</p>"
    end

    it "doesn't escape other character entities" do
      Guileless.format("&nbsp;").should == "<p>&nbsp;</p>"
      Guileless.format("&#x1f4a9;").should == "<p>&#x1f4a9;</p>"
    end

    it "understands empty attributes" do
      Guileless.format("<blockquote data-foo>stuff</blockquote>").should == "<blockquote data-foo><p>stuff</p></blockquote>"
    end

    it "understands single quoted attributes" do
      Guileless.format("<blockquote data-foo='bar'>stuff</blockquote>").should == "<blockquote data-foo='bar'><p>stuff</p></blockquote>"
    end

    it "understands double quoted attributes" do
      Guileless.format("<blockquote data-foo=\"bar\">stuff</blockquote>").should == "<blockquote data-foo=\"bar\"><p>stuff</p></blockquote>"
    end

    it "ignores non-closed tags" do
      Guileless.format("<blockquote><b>stuff</blockquote>").should == "<blockquote><p><b>stuff</p></blockquote>"
    end

    it "nests tags properly" do
      Guileless.format("foo<blockquote>bar</blockquote>baz").should == "<p>foo</p><blockquote><p>bar</p></blockquote><p>baz</p>"
    end

    it "doesn't wrap existing paragraphs" do
      Guileless.format("<p>foo</p>").should == "<p>foo</p>"
    end
  end
end