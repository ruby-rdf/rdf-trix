$:.unshift "."
require 'spec_helper'
require 'rdf/spec/writer'

describe RDF::TriX::Writer do
  before(:each) do
    @writer = RDF::TriX::Writer.new(StringIO.new)
  end
  
  include RDF_Writer

  describe ".for" do
    formats = [
      :trix,
      'etc/doap.xml',
      {:file_name      => 'etc/doap.xml'},
      {:file_extension => 'xml'},
      {:content_type   => 'application/trix'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        expect(RDF::Writer.for(arg)).to eq RDF::TriX::Writer
      end
    end
  end

end
