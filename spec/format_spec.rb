$:.unshift "."
require 'spec_helper'
require 'rdf/spec/format'

describe RDF::TriX::Format do
  before :each do
    @format_class = RDF::TriX::Format
  end

  include RDF_Format

  describe ".for" do
    formats = [
      :trix,
      'etc/doap.xml',
      {:file_name      => 'etc/doap.xml'},
      {:file_extension => 'xml'},
      {:content_type   => 'application/trix'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Format.for(arg).should == @format_class
      end
    end

    it "should discover 'trix'" do
      RDF::Format.for(:trix).reader.should == RDF::TriX::Reader
    end
  end

  describe "#to_sym" do
    specify {@format_class.to_sym.should == :trix}
  end

end
