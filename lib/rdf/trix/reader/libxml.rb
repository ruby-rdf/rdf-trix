module RDF::TriX
  class Reader < RDF::Reader
    ##
    # LibXML-Ruby implementation of the TriX reader.
    #
    # @see http://libxml.rubyforge.org/rdoc/
    module LibXML
      ##
      # Returns the name of the underlying XML library.
      #
      # @return [Symbol]
      def self.library
        :libxml
      end

      ##
      # Initializes the underlying XML library.
      #
      # @param  [Hash{Symbol => Object}] options
      # @return [void]
      def initialize_xml(options = {})
        require 'libxml' unless defined?(::LibXML)
        @xml = case @input
          when File   then ::LibXML::XML::Document.file(@input.path)
          when IO     then ::LibXML::XML::Document.io(@input)
          else ::LibXML::XML::Document.string(@input.to_s)
        end
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
        @xml.find('//trix:graph', options).each do |graph|
          graph.find('./trix:triple', options).each do |triple|
            triple = triple.children.select { |node| node.element? }[0..2]
            triple = triple.map { |element| parse_element(element.name, element.attributes, element.content) }
            block.call(*triple)
          end
        end
      end
    end # module LibXML
  end # class Reader
end # module RDF::TriX
