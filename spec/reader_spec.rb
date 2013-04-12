# coding: utf-8
$:.unshift "."
require 'spec_helper'
require 'rdf/spec/reader'

describe RDF::TriX::Reader do
  before :each do
    @reader = RDF::TriX::Reader.new(StringIO.new(""))
  end

  include RDF_Reader

  describe ".for" do
    formats = [
      :trix,
      'etc/doap.xml',
      {:file_name      => 'etc/doap.xml'},
      {:file_extension => 'xml'},
      {:content_type   => 'application/trix'},
    ].each do |arg|
      it "discovers with #{arg.inspect}" do
        RDF::Reader.for(arg).should == RDF::TriX::Reader
      end
    end
  end

  context "when parsing etc/doap.xml" do
    before :each do
      etc = File.expand_path(File.join(File.dirname(__FILE__), '..', 'etc'))
      @ntriples = RDF::NTriples::Reader.new(File.open(File.join(etc, 'doap.nt')))
      @reader = RDF::TriX::Reader.open(File.join(etc, 'doap.xml'))
    end

    it "should return the correct number of statements" do
      @reader.count.should == @ntriples.count
    end
  end
end
