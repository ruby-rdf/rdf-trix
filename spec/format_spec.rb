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
        expect(RDF::Format.for(arg)).to eq @format_class
      end
    end

    it "should discover 'trix'" do
      expect(RDF::Format.for(:trix).reader).to eq RDF::TriX::Reader
    end
  end

  describe "#to_sym" do
    specify {expect(@format_class.to_sym).to eq :trix}
  end

end
