$:.unshift "."
require 'spec_helper'
require 'rdf/spec/format'

describe RDF::TriX::Format do
  it_behaves_like 'an RDF::Format' do
    let(:format_class) {RDF::TriX::Format}
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
        expect(RDF::Format.for(arg)).to eq described_class
      end
    end

    it "should discover 'trix'" do
      expect(RDF::Format.for(:trix).reader).to eq RDF::TriX::Reader
    end
  end

  describe "#to_sym" do
    specify {expect(described_class.to_sym).to eq :trix}
  end

end
