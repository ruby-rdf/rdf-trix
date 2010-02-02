require 'rdf'

module RDF
  ##
  # **`RDF::TriX`** is a TriX plugin for RDF.rb.
  #
  # @example Requiring the `RDF::TriX` module
  #   require 'rdf/trix'
  #
  # @example Parsing RDF statements from a TriX file
  #   RDF::TriX::Reader.open("spec/data/test.xml") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Serializing RDF statements into a TriX file
  #   RDF::TriX::Writer.open("spec/data/test.xml") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://rdf.rubyforge.org/
  # @see http://swdev.nokia.com/trix/trix.html
  #
  # @author [Arto Bendiken](http://ar.to/)
  module TriX
    require 'nokogiri'
    require 'rdf/trix/format'
    autoload :Reader,  'rdf/trix/reader'
    autoload :Writer,  'rdf/trix/writer'
    autoload :VERSION, 'rdf/trix/version'
  end # module TriX
end # module RDF
