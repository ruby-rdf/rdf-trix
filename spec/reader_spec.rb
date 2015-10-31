# coding: utf-8
$:.unshift "."
require 'spec_helper'
require 'rdf/spec/reader'

describe RDF::TriX::Reader do
  let!(:doap) {File.expand_path("../../etc/doap.xml", __FILE__)}
  let!(:doap_nt) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap_nt).each_line.to_a.length}

  it_behaves_like 'an RDF::Reader' do
    let(:reader) {RDF::TriX::Reader.new(reader_input)}
    let(:reader_input) {File.read(doap)}
    let(:reader_count) {doap_count}
  end

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

  %w(nokogiri libxml rexml).each do |impl|
    next if impl == 'libxml' && defined?(:RUBY_ENGINE) && RUBY_ENGINE == "jruby"
    context impl do
      context "when parsing etc/doap.xml", focus: true do
        let(:ntriples) {RDF::Graph.load(doap_nt)}
        let(:trix) {RDF::Graph.load(doap, format: :trix, library: impl.to_sym)}

        it "should return the correct number of statements" do
          expect(trix.count).to eq ntriples.count
        end
      end
    end
  end
end
