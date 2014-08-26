# coding: utf-8
$:.unshift "."
require 'spec_helper'
require 'rdf/spec/reader'

describe RDF::TriX::Reader do
  let!(:doap) {File.expand_path("../../etc/doap.xml", __FILE__)}
  let!(:doap_nt) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap_nt).each_line.to_a.length}

  before(:each) do
    @reader_input = File.read(doap)
    @reader = RDF::TriX::Reader.new(@reader_input)
    @reader_count = doap_count
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
        expect(RDF::Reader.for(arg)).to eq RDF::TriX::Reader
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
      expect(@reader.count).to eq @ntriples.count
    end
  end
end
