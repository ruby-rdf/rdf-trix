module RDF::TriX
  class Reader < RDF::Reader
    ##
    # REXML implementation of the TriX reader.
    #
    # @see http://www.germane-software.com/software/rexml/
    module REXML
      ##
      # Returns the name of the underlying XML library.
      #
      # @return [Symbol]
      def self.library
        :rexml
      end

      ##
      # Initializes the underlying XML library.
      #
      # @param  [Hash{Symbol => Object}] options
      # @return [void]
      def initialize_xml(options = {})
        require 'rexml/document' unless defined?(::REXML)
        @xml = ::REXML::Document.new(@input, :compress_whitespace => %w{uri})
      end

      ##
      # Enumerates each triple in the TriX stream.
      #
      # @todo   Support named graphs.
      # @yield  [subject, predicate, object]
      # @yieldparam [RDF::Resource] subject
      # @yieldparam [RDF::URI]      predicate
      # @yieldparam [RDF::Value]    object
      # @return [Enumerator]
      def each_triple(&block)
        @xml.elements.each('TriX/graph/triple') do |triple|
          triple = triple.select { |node| node.kind_of?(::REXML::Element) }[0..2]
          triple = triple.map { |element| parse_element(element.name, element.attributes, element.text) }
          block.call(*triple)
        end
      end
    end # module REXML
  end # class Reader
end # module RDF::TriX
