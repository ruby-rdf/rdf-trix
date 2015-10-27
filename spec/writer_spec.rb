$:.unshift "."
require 'spec_helper'
require 'rdf/spec/writer'

describe RDF::TriX::Writer do
  it_behaves_like 'an RDF::Writer' do
    let(:writer) {RDF::TriX::Writer.new}
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
        expect(RDF::Writer.for(arg)).to eq RDF::TriX::Writer
      end
    end
  end

  %w(nokogiri rexml).each do |impl|
    context impl do
      it "serializes doap" do
        graph = RDF::Graph.load(File.expand_path("../../etc/doap.nt", __FILE__))
        expect {graph.dump(:trix, library: impl.to_sym)}.not_to raise_error
      end
    end
  end
end
