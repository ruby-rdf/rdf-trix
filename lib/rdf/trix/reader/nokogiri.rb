module RDF::TriX
  class Reader < RDF::Reader
    ##
    # Nokogiri implementation of the TriX reader.
    #
    # @see http://nokogiri.org/
    module Nokogiri
      OPTIONS = {'trix' => Format::XMLNS}.freeze

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
          @xml.xpath('//trix:graph', OPTIONS).each do |graph|
            graph.xpath('./trix:triple', OPTIONS).each do |triple|
              triple = triple.children.select { |node| node.element? }[0..2]
              triple = triple.map { |element| parse_element(element.name, element, element.content) }
              block.call(RDF::Statement.new(*triple))
            end
          end
        end
      end
    end # module Nokogiri
  end # class Reader
end # module RDF::TriX
