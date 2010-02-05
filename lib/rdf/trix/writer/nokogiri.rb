module RDF::TriX
  class Writer < RDF::Writer
    ##
    # Nokogiri implementation of the TriX writer.
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
        @xml = ::Nokogiri::XML::Document.new
        @xml.encoding = @encoding
      end

      ##
      # Generates the TriX root element.
      #
      # @return [void]
      def write_prologue
        @trix  = create_element(:TriX, nil, :xmlns => Format::XMLNS)
        @graph = create_element(:graph)
        @xml << @trix << @graph
      end

      ##
      # Outputs the TriX document.
      #
      # @return [void]
      def write_epilogue
        puts @xml.to_xml
        @xml = @trix = @graph = nil
      end

      ##
      # Creates an XML comment element with the given `text`.
      #
      # @param  [String, #to_s] text
      # @return [Nokogiri::XML::Comment]
      def create_comment(text)
        ::Nokogiri::XML::Comment.new(@xml, text.to_s)
      end

      ##
      # Creates an XML element of the given `name`, with optional given
      # `content` and `attributes`.
      #
      # @param  [Symbol, String, #to_s]  name
      # @param  [String, #to_s]          content
      # @param  [Hash{Symbol => Object}] attributes
      # @yield  [element]
      # @yieldparam [Nokogiri::XML::Element] element
      # @return [Nokogiri::XML::Element]
      def create_element(name, content = nil, attributes = {}, &block)
        element = @xml.create_element(name.to_s)
        if xmlns = attributes.delete(:xmlns)
          element.default_namespace = xmlns
        end
        attributes.each { |k, v| element[k.to_s] = v }
        element.content = content.to_s unless content.nil?
        block.call(element) if block_given?
        element
      end
    end # module Nokogiri
  end # class Writer
end # module RDF::TriX
