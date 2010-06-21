module RDF::TriX
  class Reader < RDF::Reader
    ##
    # LibXML-Ruby implementation of the TriX reader.
    #
    # @see http://libxml.rubyforge.org/rdoc/
    module LibXML
      OPTIONS = {'trix' => Format::XMLNS}.freeze

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
      # @private
      # @see RDF::Reader#each_graph
      def each_graph(&block)
        unless block_given?
          enum_for(:each_graph)
        else
          # TODO
        end
      end

      ##
      # @private
      # @see RDF::Reader#each_statement
      def each_statement(&block)
        unless block_given?
          enum_for(:each_statement)
        else
          @xml.find('//trix:graph', OPTIONS).each do |graph|
            graph.find('./trix:triple', OPTIONS).each do |triple|
              triple = triple.children.select { |node| node.element? }[0..2]
              triple = triple.map { |element| parse_element(element.name, element.attributes, element.content) }
              block.call(RDF::Statement.new(*triple))
            end
          end
        end
      end
    end # module LibXML
  end # class Reader
end # module RDF::TriX
