# coding: utf-8
$:.unshift "."
require 'spec_helper'
require 'rdf/spec/reader'
require 'rdf/ordered_repo'

describe RDF::TriX::Reader do
  let(:logger) {RDF::Spec.logger}
  let!(:doap) {File.expand_path("../../etc/doap.xml", __FILE__)}
  let!(:doap_nt) {File.expand_path("../../etc/doap.nt", __FILE__)}
  let!(:doap_count) {File.open(doap_nt).each_line.to_a.length}

  it_behaves_like 'an RDF::Reader' do
    let(:reader) {RDF::TriX::Reader.new(reader_input, logger: logger)}
    let(:reader_input) {File.read(doap)}
    let(:reader_count) {doap_count}
  end

  describe ".for" do
    [
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

        it "should be isomorphic" do
          expect(trix).to be_equivalent_graph(ntriples)
        end
      end

      context "examples" do
        {
          example1: {
            input: %(
              <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                <graph>
                  <uri>http://example.org/graph1</uri>
                  <triple>
                    <uri>http://example.org/Bob</uri>
                    <uri>http://example.org/wife</uri>
                    <uri>http://example.org/Mary</uri>
                  </triple>
                  <triple>
                    <uri>http://example.org/Bob</uri>
                    <uri>http://example.org/name</uri>
                    <plainLiteral>Bob</plainLiteral>
                  </triple>
                  <triple>
                    <uri>http://example.org/Mary</uri>
                    <uri>http://example.org/age</uri>
                    <typedLiteral datatype="http://www.w3.org/2001/XMLSchema#integer">32</typedLiteral>
                  </triple>
               </graph>
            </TriX>),
            expect: %(
              <http://example.org/Bob> <http://example.org/wife> <http://example.org/Mary> <http://example.org/graph1> .
              <http://example.org/Bob> <http://example.org/name> "Bob" <http://example.org/graph1> .
              <http://example.org/Mary> <http://example.org/age> "32"^^<http://www.w3.org/2001/XMLSchema#integer> <http://example.org/graph1> .
            )
          },
          example3: {
            input: %q(
              <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                <graph>
                  <uri>http://example.org/graph3</uri>
                  <triple>
                    <uri>http://example.org/aBook</uri>
                    <uri>http://purl.org/dc/elements/1.1/title</uri>
                    <typedLiteral
                      datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral">
                      <ex:title xmlns:ex="http://example.org/">
                        A Good Book
                      </ex:title>
                    </typedLiteral>
                  </triple>
                  <triple>
                    <uri>http://example.org/aBook</uri>
                    <uri>http://www.w3.org/2000/01/rdf-schema#comment</uri>
                    <plainLiteral xml:lang="en">This is a really good book!</plainLiteral>
                  </triple>
                  <triple>
                    <uri>http://example.org/graph3</uri>
                    <uri>http://example.org/source</uri>
                    <uri>http://example.org/book-description.rdf</uri>
                  </triple>
                </graph>
              </TriX>
            ),
            expect: %q(
              <http://example.org/aBook> <http://purl.org/dc/elements/1.1/title> "\n                      <ex:title xmlns:ex=\"http://example.org/\">\n                        A Good Book\n                      </ex:title>\n                    "^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral> <http://example.org/graph3> .
              <http://example.org/aBook> <http://www.w3.org/2000/01/rdf-schema#comment> "This is a really good book!"@en <http://example.org/graph3> .
              <http://example.org/graph3> <http://example.org/source> <http://example.org/book-description.rdf> <http://example.org/graph3> .
            ),
            except: :rexml
          },
          example4: {
            input: %(
              <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                <graph>
                  <uri>http://example.org/graph4</uri>
                  <triple>
                    <uri>http://example.org/aBook</uri>
                      <uri>http://purl.org/dc/elements/1.1/title</uri>
                      <typedLiteral
                        datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral">
                        <ex:title xmlns:ex="http://example.org/">
                          A Good Book
                        </ex:title>
                      </typedLiteral>
                    </triple>
                    <triple>
                      <uri>http://example.org/aBook</uri>
                      <uri>http://www.w3.org/2000/01/rdf-schema#comment</uri>
                      <plainLiteral xml:lang="en">This is a really good book!</plainLiteral>
                    </triple>
                </graph>
                <graph>
                  <uri>http://example.org/graph5</uri>
                  <triple>
                    <uri>http://example.org/graph4</uri>
                    <uri>http://example.org/source</uri>
                    <uri>http://example.org/book-description.rdf</uri>
                  </triple>
                </graph>
              </TriX>
            ),
            expect: %q(
              <http://example.org/aBook> <http://purl.org/dc/elements/1.1/title> "\n                        <ex:title xmlns:ex=\"http://example.org/\">\n                          A Good Book\n                        </ex:title>\n                      "^^<http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral> <http://example.org/graph4> .
              <http://example.org/aBook> <http://www.w3.org/2000/01/rdf-schema#comment> "This is a really good book!"@en <http://example.org/graph4> .
              <http://example.org/graph4> <http://example.org/source> <http://example.org/book-description.rdf> <http://example.org/graph5> .
            ),
            except: :rexml
          },
          example5: {
            input: %q(
              <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                <graph>
                  <uri>http://example.org/graph6</uri>
                  <triple>
                    <uri>http://example.org/tests/language-tag-case</uri>
                    <uri>http://example.org/entailmentRules</uri>
                    <uri>http://www.w3.org/199902/22-rdf-syntax-ns#</uri>
                  </triple>
                  <triple>
                    <uri>http://example.org/tests/langauge-tag-case</uri>
                    <uri>http://example.org/premis</uri>
                    <uri>http://example.org/tests/graph1</uri>
                  </triple>
                </graph>
                <graph>
                  <uri>http://example.org/tests/graph1</uri>
                  <triple>
                    <id>x</id>
                    <uri>http://example.org/property</uri>
                    <plainLiteral xml:lang="en">a</plainLiteral>
                  </triple>
                </graph>
                <graph>
                  <uri>http://example.org/tests/graph2</uri>
                  <triple>
                    <id>x</id>
                    <uri>http://example.org/property</uri>
                    <plainLiteral xml:lang="en-US">a</plainLiteral>
                  </triple>
                </graph>
              </TriX>
            ),
            expect: %(
              <http://example.org/tests/language-tag-case> <http://example.org/entailmentRules> <http://www.w3.org/199902/22-rdf-syntax-ns#> <http://example.org/graph6> .
              <http://example.org/tests/langauge-tag-case> <http://example.org/premis> <http://example.org/tests/graph1> <http://example.org/graph6> .
              _:x <http://example.org/property> "a"@en <http://example.org/tests/graph1> .
              _:x <http://example.org/property> "a"@en-us <http://example.org/tests/graph2> .
            )
          },
          #"qnames": {
          #  input: %(
          #    <?xml-stylesheet type="text/xml" href="http://www.w3.org/2004/03/trix/all.xsl"?>
          #    <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/"
          #          xmlns:eg="http://example.org/">
          #      <graph>
          #        <uri>http://example.org/graph2</uri>
          #        <triple>
          #          <qname>eg:Bob</qname>
          #          <qname>eg:wife</qname>
          #          <qname>eg:Mary</qname>
          #        </triple>
          #        <triple>
          #          <qname>eg:Bob</qname>
          #          <qname>eg:name</qname>
          #          <plainLiteral>Bob</plainLiteral>
          #        </triple>
          #        <triple>
          #          <qname>eg:Mary</qname>
          #          <qname>eg:age</qname>
          #          <integer>32</integer>
          #        </triple>
          #     </graph>
          #  </TriX>
          #  ),
          #  expect: %(
          #  )
          #},
          "xml:base": {
            input: %(
              <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/"
                    xml:base="http://example.org/">
                <graph>
                  <uri>graph1</uri>
                  <triple>
                    <uri>Bob</uri>
                    <uri>wife</uri>
                    <uri>Mary</uri>
                  </triple>
                  <triple>
                    <uri>Bob</uri>
                    <uri>name</uri>
                    <plainLiteral>Bob</plainLiteral>
                  </triple>
                  <triple>
                    <uri>Mary</uri>
                    <uri>age</uri>
                    <typedLiteral datatype="http://www.w3.org/2001/XMLSchema#integer">32</typedLiteral>
                  </triple>
               </graph>
            </TriX>),
            expect: %(
              <http://example.org/Bob> <http://example.org/wife> <http://example.org/Mary> <http://example.org/graph1> .
              <http://example.org/Bob> <http://example.org/name> "Bob" <http://example.org/graph1> .
              <http://example.org/Mary> <http://example.org/age> "32"^^<http://www.w3.org/2001/XMLSchema#integer> <http://example.org/graph1> .
            ),
            except: :rexml
          },
        }.each do |name, params|
          it name do
            res = RDF::OrderedRepo.new << RDF::NQuads::Reader.new(params[:expect])
            expect(parse(params[:input], library: impl.to_sym, **params)).to be_equivalent_graph(res, logger: @logger)
          end unless Array(params[:except]).include?(impl.to_sym)
        end

        context "RDF-star" do
          it "raises an error if rdfstar option not set" do
            trix = %(
              <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                <graph>
                  <triple>
                    <triple>
                      <uri>http://example/s1</uri>
                      <uri>http://example/p1</uri>
                      <uri>http://example/o1</uri>
                    </triple>
                    <uri>http://example/p</uri>
                    <uri>http://example/o</uri>
                  </triple>
                </graph>
              </TriX>)

            expect {parse(trix, validate: true, library: impl.to_sym)}.to raise_error(RDF::ReaderError)
          end

          {
            'turtle-eval-01': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <triple>
                      <triple>
                        <uri>http://example/s</uri>
                        <uri>http://example/p</uri>
                        <uri>http://example/o</uri>
                      </triple>
                      <uri>http://example/q</uri>
                      <uri>http://example/z</uri>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                << <http://example/s> <http://example/p> <http://example/o> >> <http://example/q> <http://example/z> .
              )
            },
            'turtle-eval-02': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <triple>
                      <uri>http://example/a</uri>
                      <uri>http://example/q</uri>
                      <triple>
                        <uri>http://example/s</uri>
                        <uri>http://example/p</uri>
                        <uri>http://example/o</uri>
                      </triple>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                <http://example/a> <http://example/q> << <http://example/s> <http://example/p> <http://example/o> >> .
              )
            },
            'turtle-eval-bnode-1': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <triple>
                      <id>b</id>
                      <uri>http://example/p</uri>
                      <uri>http://example/o</uri>
                    </triple>
                    <triple>
                      <triple>
                        <id>b</id>
                        <uri>http://example/p</uri>
                        <uri>http://example/o</uri>
                      </triple>
                      <uri>http://example/q</uri>
                      <uri>http://example/z</uri>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                _:b9 <http://example/p> <http://example/o> .
                << _:b9 <http://example/p> <http://example/o> >> <http://example/q> <http://example/z> .
              )
            },
            'turtle-eval-bnode-2': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <triple>
                      <id>a</id>
                      <uri>http://example/p1</uri>
                      <id>a</id>
                    </triple>
                    <triple>
                      <triple>
                        <id>a</id>
                        <uri>http://example/p1</uri>
                        <id>a</id>
                      </triple>
                      <uri>http://example/q</uri>
                      <triple>
                        <id>a</id>
                        <uri>http://example/p2</uri>
                        <uri>http://example/o</uri>
                      </triple>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                _:label1 <http://example/p1> _:label1 .
                << _:label1 <http://example/p1> _:label1 >> <http://example/q> << _:label1 <http://example/p2> <http://example/o> >> .
              )
            },
            'trig-eval-01': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <uri>http://example/G</uri>
                    <triple>
                      <triple>
                        <uri>http://example/s</uri>
                        <uri>http://example/p</uri>
                        <uri>http://example/o</uri>
                      </triple>
                      <uri>http://example/q</uri>
                      <uri>http://example/z</uri>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                << <http://example/s> <http://example/p> <http://example/o> >> <http://example/q> <http://example/z> <http://example/G> <http://example/G> .
              )
            },
            'trig-eval-02': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <uri>http://example/G</uri>
                    <triple>
                      <uri>http://example/a</uri>
                      <uri>http://example/q</uri>
                      <triple>
                        <uri>http://example/s</uri>
                        <uri>http://example/p</uri>
                        <uri>http://example/o</uri>
                      </triple>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                <http://example/a> <http://example/q> << <http://example/s> <http://example/p> <http://example/o> >> <http://example/G> .
              )
            },
            'trig-eval-bnode-1': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <uri>http://example/G</uri>
                    <triple>
                      <id>b</id>
                      <uri>http://example/p</uri>
                      <uri>http://example/o</uri>
                    </triple>
                    <triple>
                      <triple>
                        <id>b</id>
                        <uri>http://example/p</uri>
                        <uri>http://example/o</uri>
                      </triple>
                      <uri>http://example/q</uri>
                      <uri>http://example/z</uri>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                _:b9 <http://example/p> <http://example/o> <http://example/G> .
                << _:b9 <http://example/p> <http://example/o> >> <http://example/q> <http://example/z> <http://example/G> .
              )
            },
            'trig-eval-bnode-2': {
              input: %(
                <TriX xmlns="http://www.w3.org/2004/03/trix/trix-1/">
                  <graph>
                    <uri>http://example/G</uri>
                    <triple>
                      <id>a</id>
                      <uri>http://example/p1</uri>
                      <id>a</id>
                    </triple>
                    <triple>
                      <triple>
                        <id>a</id>
                        <uri>http://example/p1</uri>
                        <id>a</id>
                      </triple>
                      <uri>http://example/q</uri>
                      <triple>
                        <id>a</id>
                        <uri>http://example/p2</uri>
                        <uri>http://example/o</uri>
                      </triple>
                    </triple>
                  </graph>
                </TriX>),
              expect: %(
                _:label1 <http://example/p1> _:label1 <http://example/G> .
                << _:label1 <http://example/p1> _:label1 >> <http://example/q> << _:label1 <http://example/p2> <http://example/o> >> <http://example/G> .
              )
            },
          }.each do |name, params|
            it name do
              res = RDF::OrderedRepo.new << RDF::NQuads::Reader.new(params[:expect], rdfstar: true)
              expect(parse(params[:input], library: impl.to_sym, rdfstar: true, **params)).to be_equivalent_graph(res, logger: @logger)
            end unless Array(params[:except]).include?(impl.to_sym)
          end
        end
      end
    end
  end

  def parse(input, **options)
    @logger = RDF::Spec.logger
    options = {
      logger: @logger,
      validate: false,
      canonicalize: false,
    }.merge(options)
    graph = options[:graph] || RDF::OrderedRepo.new
    RDF::TriX::Reader.new(input, **options).each do |statement|
      graph << statement
    end
    graph
  end
end
