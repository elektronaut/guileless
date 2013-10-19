require 'spec_helper'

describe SimpleParser do
  describe ".parse" do
    subject { SimpleParser.parse(input) }

    describe "" do
      let(:input) { "<!-- comment -->\n\n>_<3 foo\n\n\n<div><blockquote foo=\"bar\" bar='single' baz>in\n\n a\n<span><img src=\"a.png\" >quote</span>\n\nyeah</blockquote></div>next line" }
      it { should == "<!-- comment --><p>&gt;_&lt;3 foo</p><div><blockquote foo=\"bar\" bar='single' baz><p>in</p><p> a<br><span><img src=\"a.png\" >quote</span></p><p>yeah</p></blockquote></div><p>next line</p>" }
    end

    describe "HTML comment" do
      let(:input) { "<!-- this is a <b>comment</b> -->" }
      it { should == input }
    end

  end
end