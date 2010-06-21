module RDF::TriX
  class Reader < RDF::Reader
    ##
    # REXML implementation of the TriX reader.
    #
    # @see http://www.germane-software.com/software/rexml/
    module REXML
      OPTIONS = {}.freeze

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
          @xml.elements.each('TriX/graph/triple') do |triple|
            triple = triple.select { |node| node.kind_of?(::REXML::Element) }[0..2]
            triple = triple.map { |element| parse_element(element.name, element.attributes, element.text) }
            block.call(RDF::Statement.new(*triple))
          end
        end
      end
    end # module REXML
  end # class Reader
end # module RDF::TriX
