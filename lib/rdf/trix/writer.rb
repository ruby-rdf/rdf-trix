module RDF::TriX
  ##
  # TriX serializer.
  #
  # @example Obtaining a TriX writer class
  #   RDF::Writer.for(:trix)         #=> RDF::TriX::Writer
  #   RDF::Writer.for("spec/data/test.xml")
  #   RDF::Writer.for(:file_name      => "spec/data/test.xml")
  #   RDF::Writer.for(:file_extension => "xml")
  #   RDF::Writer.for(:content_type   => "application/trix")
  #
  # @example Serializing RDF statements into a TriX file
  #   RDF::TriX::Writer.open("spec/data/test.xml") do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @example Serializing RDF statements into a TriX string
  #   RDF::TriX::Writer.buffer do |writer|
  #     graph.each_statement do |statement|
  #       writer << statement
  #     end
  #   end
  #
  # @see http://www.w3.org/2004/03/trix/
  class Writer < RDF::Writer
    format  RDF::TriX::Format
    include Nokogiri

    ##
    # Initializes the TriX writer instance.
    #
    # @param  [IO, File] output
    # @param  [Hash{Symbol => Object}] options
    # @option options [String, #to_s] :encoding ('utf-8')
    # @yield  [writer]
    # @yieldparam [Writer] writer
    def initialize(output = $stdout, options = {}, &block)
      require 'nokogiri' unless defined?(::Nokogiri)
      @xml = XML::Document.new
      @xml.encoding = (options[:encoding] || 'utf-8').to_s
      super
    end

    ##
    # Generates the TriX root element.
    #
    # @return [void]
    def write_prologue
      @trix  = create_element(:TriX, :xmlns => Format::XMLNS)
      @graph = create_element(:graph)
      @xml << @trix << @graph
    end

    ##
    # Generates an XML comment.
    #
    # @param  [String, #to_s] text
    # @return [void]
    def write_comment(text)
      @graph << XML::Comment.new(@xml, text.to_s)
    end

    ##
    # Generates the TriX representation of a triple.
    #
    # @param  [RDF::Resource] subject
    # @param  [RDF::URI]      predicate
    # @param  [RDF::Value]    object
    # @return [void]
    def write_triple(subject, predicate, object)
      @graph << format_triple(subject, predicate, object)
    end

    ##
    # Outputs the TriX representation of all stored triples.
    #
    # @return [void]
    def write_epilogue
      puts @xml.to_xml
      @xml = @trix = @graph = nil
    end

    ##
    # Returns the TriX representation of a triple.
    #
    # @param  [RDF::Resource] subject
    # @param  [RDF::URI]      predicate
    # @param  [RDF::Value]    object
    # @return [Nokogiri::XML::Element]
    def format_triple(subject, predicate, object)
      create_element(:triple) do |triple|
        triple << format_value(subject)
        triple << format_uri(predicate)
        triple << format_value(object)
      end
    end

    ##
    # Returns the TriX representation of a blank node.
    #
    # @param  [RDF::Node] value
    # @param  [Hash{Symbol => Object}] options
    # @return [Nokogiri::XML::Element]
    def format_node(value, options = {})
      create_element(:id) do |element|
        # TODO: should we be relying on object identity instead of on the
        # specified blank node identifier as we're doing now? That is,
        # is `RDF::Node.new(1) != RDF::Node.new(1)` to be true or false?
        element.content = value.id.to_s
      end
    end

    ##
    # Returns the TriX representation of a URI reference.
    #
    # @param  [RDF::URI] value
    # @param  [Hash{Symbol => Object}] options
    # @return [Nokogiri::XML::Element]
    def format_uri(value, options = {})
      create_element(:uri) do |element|
        element.content = value.to_s
      end
    end

    ##
    # Returns the TriX representation of a literal.
    #
    # @param  [RDF::Literal, String, #to_s] value
    # @param  [Hash{Symbol => Object}] options
    # @return [Nokogiri::XML::Element]
    def format_literal(value, options = {})
      value = RDF::Literal.new(value) unless value.is_a?(RDF::Literal)
      case
        when value.datatype? # FIXME: use `has_datatype?` in RDF.rb 0.1.0
          create_element(:typedLiteral) do |element|
            element['datatype'] = value.datatype.to_s
            element.content = value.value.to_s
          end
        when value.language? # FIXME: use `has_language?` in RDF.rb 0.1.0
          create_element(:plainLiteral) do |element|
            element['xml:lang'] = value.language.to_s
            element.content = value.value.to_s
          end
        else
          create_element(:plainLiteral) do |element|
            element.content = value.value.to_s
          end
      end
    end

    ##
    # Creates an XML element of the given `name`, with optional given
    # `attributes`.
    #
    # @param  [Symbol, String, #to_s]  name
    # @param  [Hash{Symbol => Object}] attributes
    # @yield  [element]
    # @yieldparam [Nokogiri::XML::Element] element
    # @return [Nokogiri::XML::Element]
    def create_element(name, attributes = {}, &block)
      element = @xml.create_element(name.to_s)
      if xmlns = attributes.delete(:xmlns)
        element.default_namespace = xmlns
      end
      attributes.each { |k, v| element[k.to_s] = v }
      block.call(element) if block_given?
      element
    end

    protected :create_element
  end # class Writer
end # module RDF::TriX
