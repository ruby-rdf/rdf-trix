module RDF::TriX
  class Reader < RDF::Reader
    ##
    # LibXML-Ruby implementation of the TriX reader.
    #
    # @see https://rubygems.org/gems/libxml-ruby/
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
      def initialize_xml(input, **options)
        require 'libxml' unless defined?(::LibXML)
        @xml = case input
          when File         then ::LibXML::XML::Document.file(input.path)
          when IO, StringIO then ::LibXML::XML::Document.io(input)
          else ::LibXML::XML::Document.string(input.to_s)
        end
      end

      ##
      # @private
      # @see RDF::Reader#each_graph
      def each_graph(&block)
        if block_given?
          @xml.find('//trix:graph', OPTIONS).each do |graph_element|
            graph = RDF::Graph.new(graph_name: read_graph(graph_element))
            read_statements(graph_element) { |statement| graph << statement }
            block.call(graph)
          end
        end
        enum_graph
      end

      ##
      # @private
      # @see RDF::Reader#each_statement
      def each_statement(&block)
        if block_given?
          @xml.find('//trix:graph', OPTIONS).each do |graph_element|
            read_statements(graph_element, &block)
          end
        end
        enum_statement
      end

    protected

      ##
      # @private
      def read_graph(graph_element)
        name = graph_element.children.select { |node| node.element? && node.name.to_s == 'uri' }.first.content.strip rescue nil
        name ? RDF::URI.intern(name) : nil
      end

      ##
      # @private
      def triple_elements(element)
        element.find('./trix:triple', OPTIONS)
      end

      ##
      # @private
      def element_elements(element)
        element.children.select { |node| node.element? }
      end

      ##
      # @private
      def element_content(element)
        element.content
      end
    end # LibXML
  end # Reader
end # RDF::TriX
