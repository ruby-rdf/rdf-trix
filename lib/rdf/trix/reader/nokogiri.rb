module RDF::TriX
  class Reader < RDF::Reader
    ##
    # Nokogiri implementation of the TriX reader.
    #
    # @see http://nokogiri.org/
    module Nokogiri
      ##
      # Returns the name of the underlying XML library.
      #
      # @return [Symbol]
      def self.library
        :nokogiri
      end

      ##
      # Initializes the underlying XML library.
      #
      # @param  [Hash{Symbol => Object}] options
      # @return [void]
      def initialize_xml(options = {})
        require 'nokogiri' unless defined?(::Nokogiri)
        @xml = ::Nokogiri::XML(@input)
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
        options = {'trix' => Format::XMLNS}
        @xml.xpath('//trix:graph', options).each do |graph|
          graph.xpath('./trix:triple', options).each do |triple|
            triple = triple.children.select { |node| node.element? }[0..2]
            triple = triple.map { |element| parse_element(element.name, element, element.content) }
            block.call(*triple)
          end
        end
      end
    end # module Nokogiri
  end # class Reader
end # module RDF::TriX
