$:.unshift "."
require 'spec_helper'
require 'rdf/spec/writer'
require 'rdf/ordered_repo'

describe RDF::TriX::Writer do
  let!(:doap_nt) {File.expand_path("../../etc/doap.nt", __FILE__)}

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
      let(:doap) {RDF::Graph.load(doap_nt)}
      let(:doap_trix) {doap.dump(:trix, library: impl.to_sym)}

      it "serializes doap" do
        expect(RDF::Graph.new << RDF::TriX::Reader.new(doap_trix)).to be_equivalent_graph(doap)
      end

      context "examples" do
        {
          example1: {
            input: %(
              <http://example.org/Bob> <http://example.org/wife> <http://example.org/Mary> <http://example.org/graph1> .
              <http://example.org/Bob> <http://example.org/name> "Bob" <http://example.org/graph1> .
              <http://example.org/Mary> <http://example.org/age> "32"^^<http://www.w3.org/2001/XMLSchema#integer> <http://example.org/graph1> .
            )
          },
          example3: {
            input: %q(
              <http://example.org/aBook> <http://purl.org/dc/elements/1.1/title> "\n                      <ex:title xmlns:ex=\"http://example.org/\">\n                        A Good Book\n                      </ex:title>\n                    "^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral> <http://example.org/graph3> .
              <http://example.org/aBook> <http://www.w3.org/2000/01/rdf-schema#comment> "This is a really good book!"@en <http://example.org/graph3> .
              <http://example.org/graph3> <http://example.org/source> <http://example.org/book-description.rdf> <http://example.org/graph3> .
            ),
            except: :rexml
          },
          example4: {
            input: %q(
              <http://example.org/aBook> <http://purl.org/dc/elements/1.1/title> "\n                        <ex:title xmlns:ex=\"http://example.org/\">\n                          A Good Book\n                        </ex:title>\n                      "^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral> <http://example.org/graph4> .
              <http://example.org/aBook> <http://www.w3.org/2000/01/rdf-schema#comment> "This is a really good book!"@en <http://example.org/graph4> .
              <http://example.org/graph4> <http://example.org/source> <http://example.org/book-description.rdf> <http://example.org/graph5> .
            ),
            except: :rexml
          },
          example5: {
            input: %(
              <http://example.org/tests/language-tag-case> <http://example.org/entailmentRules> <http://www.w3.org/199902/22-rdf-syntax-ns#> <http://example.org/graph6> .
              <http://example.org/tests/langauge-tag-case> <http://example.org/premis> <http://example.org/tests/graph1> <http://example.org/graph6> .
              _:x <http://example.org/property> "a"@en <http://example.org/tests/graph1> .
              _:x <http://example.org/property> "a"@en-us <http://example.org/tests/graph2> .
            )
          },
        }.each do |name, params|
          it name do
            graph = RDF::Repository.new << RDF::NQuads::Reader.new(params[:input])
            trix = graph.dump(:trix)
            graph2 = RDF::Repository.new << RDF::TriX::Reader.new(trix)
            expect(graph2).to be_equivalent_graph(graph)
          end
        end
      end

      context "with base" do
        subject do
          nt = %(
            <http://release/a> <http://foo/ref> <http://release/b> .
          )
          graph = RDF::Repository.new << RDF::NQuads::Reader.new(nt)
          graph.dump(:trix, base_uri: "http://release/")
        end

        {
          "/trix:TriX/@xml:base" => "http://release/",
          "/trix:TriX/trix:graph/trix:triple/trix:uri[1]/text()" => "a",
          "/trix:TriX/trix:graph/trix:triple/trix:uri[2]/text()" => "http://foo/ref",
          "/trix:TriX/trix:graph/trix:triple/trix:uri[3]/text()" => "b",
        }.each do |path, value|
          it "returns #{value.inspect} for xpath #{path}" do
            expect(subject).to have_xpath(path, value, {})
          end
        end
      end

      context "RDF-star" do
        {
          "subject-iii": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::URI('http://example/s1'),
                RDF::URI('http://example/p1'),
                RDF::URI('http://example/o1')),
              RDF::URI('http://example/p'),
              RDF::URI('http://example/o'))
          },
          "subject-iib": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::URI('http://example/s1'),
                RDF::URI('http://example/p1'),
                RDF::Node.new('o1')),
              RDF::URI('http://example/p'),
              RDF::URI('http://example/o')),
          },
          "subject-iil": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::URI('http://example/s1'),
                RDF::URI('http://example/p1'),
                RDF::Literal('o1')),
              RDF::URI('http://example/p'),
              RDF::URI('http://example/o')),
          },
          "subject-bii": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::Node('s1'),
                RDF::URI('http://example/p1'),
                RDF::URI('http://example/o1')),
              RDF::URI('http://example/p'),
              RDF::URI('http://example/o')),
          },
          "subject-bib": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::Node('s1'),
                RDF::URI('http://example/p1'),
                RDF::Node.new('o1')),
              RDF::URI('http://example/p'), RDF::URI('http://example/o')),
          },
          "subject-bil": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::Node('s1'),
                RDF::URI('http://example/p1'),
                RDF::Literal('o1')),
              RDF::URI('http://example/p'),
              RDF::URI('http://example/o')),
          },
          "object-iii":  {
            input: RDF::Statement(
              RDF::URI('http://example/s'),
              RDF::URI('http://example/p'),
              RDF::Statement(
                RDF::URI('http://example/s1'),
                RDF::URI('http://example/p1'),
                RDF::URI('http://example/o1'))),
          },
          "object-iib":  {
            input: RDF::Statement(
              RDF::URI('http://example/s'),
              RDF::URI('http://example/p'),
              RDF::Statement(
                RDF::URI('http://example/s1'),
                RDF::URI('http://example/p1'),
                RDF::Node.new('o1'))),
          },
          "object-iil":  {
            input: RDF::Statement(
              RDF::URI('http://example/s'),
              RDF::URI('http://example/p'),
              RDF::Statement(
                RDF::URI('http://example/s1'),
                RDF::URI('http://example/p1'),
                RDF::Literal('o1'))),
          },
          "recursive-subject": {
            input: RDF::Statement(
              RDF::Statement(
                RDF::Statement(
                  RDF::URI('http://example/s2'),
                  RDF::URI('http://example/p2'),
                  RDF::URI('http://example/o2')),
                RDF::URI('http://example/p1'),
                RDF::URI('http://example/o1')),
              RDF::URI('http://example/p'),
              RDF::URI('http://example/o')),
          },
        }.each do |name, params|
          it name do
            graph = RDF::Repository.new {|g| g << params[:input]}
            trix = graph.dump(:trix)
            graph2 = RDF::Repository.new << RDF::TriX::Reader.new(trix, rdfstar: true)
            expect(graph2).to be_equivalent_graph(graph)
          end
        end
      end
    end
  end
end
