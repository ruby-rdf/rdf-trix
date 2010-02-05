module RDF::TriX
  ##
  # TriX serializer.
  #
  # This class supports both [REXML][] and [Nokogiri][] for XML processing,
  # and will automatically select the most performant implementation
  # (Nokogiri) when it is available. If need be, you can explicitly
  # override the used implementation by passing in a `:library` option to
  # `Writer.new` or `Writer.open`.
  #
  # [REXML]:    http://www.germane-software.com/software/rexml/
  # [Nokogiri]: http://nokogiri.org/
  #
  # @example Obtaining a TriX writer class
  #   RDF::Writer.for(:trix)         #=> RDF::TriX::Writer
  #   RDF::Writer.for("spec/data/test.xml")
  #   RDF::Writer.for(:file_name      => "spec/data/test.xml")
  #   RDF::Writer.for(:file_extension => "xml")
  #   RDF::Writer.for(:content_type   => "application/trix")
  #
  # @example Instantiating a REXML-based writer
  #   RDF::TriX::Writer.new(output, :library => :rexml)
  #
  # @example Instantiating a Nokogiri-based writer
  #   RDF::TriX::Writer.new(output, :library => :nokogiri)
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
    format RDF::TriX::Format

    ##
    # Initializes the TriX writer instance.
    #
    # @param  [IO, File]               output
    # @param  [Hash{Symbol => Object}] options
    # @option options [Symbol]         :library  (:rexml or :nokogiri)
    # @option options [String, #to_s]  :encoding ('utf-8')
    # @yield  [writer]
    # @yieldparam [Writer] writer
    def initialize(output = $stdout, options = {}, &block)
      @encoding = (options[:encoding] || 'utf-8').to_s
      @implementation = case (library = options[:library])
        when nil
          # Use Nokogiri when available, but fall back to REXML otherwise:
          begin
            require 'nokogiri'
            Nokogiri
          rescue LoadError => e
            REXML
          end
        when :nokogiri then Nokogiri
        when :rexml    then REXML
        else raise ArgumentError.new("expected :rexml or :nokogiri, got #{library.inspect}")
      end
      self.extend(@implementation)
      initialize_xml(options)
      super
    end

    ##
    # Generates an XML comment.
    #
    # @param  [String, #to_s] text
    # @return [void]
    def write_comment(text)
      @graph << create_comment(text)
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
    # Returns the TriX representation of a triple.
    #
    # @param  [RDF::Resource]          subject
    # @param  [RDF::URI]               predicate
    # @param  [RDF::Value]             object
    # @param  [Hash{Symbol => Object}] options
    # @return [Element]
    def format_triple(subject, predicate, object, options = {})
      create_element(:triple) do |triple|
        triple << format_value(subject, options)
        triple << format_uri(predicate, options)
        triple << format_value(object, options)
      end
    end

    ##
    # Returns the TriX representation of a blank node.
    #
    # @param  [RDF::Node]              value
    # @param  [Hash{Symbol => Object}] options
    # @return [Element]
    def format_node(value, options = {})
      # TODO: should we be relying on object identity instead of on the
      # specified blank node identifier as we're doing now? That is,
      # is `RDF::Node.new(1) != RDF::Node.new(1)` to be true or false?
      create_element(:id, value.id.to_s)
    end

    ##
    # Returns the TriX representation of a URI reference.
    #
    # @param  [RDF::URI]               value
    # @param  [Hash{Symbol => Object}] options
    # @return [Element]
    def format_uri(value, options = {})
      create_element(:uri, value.to_s)
    end

    ##
    # Returns the TriX representation of a literal.
    #
    # @param  [RDF::Literal, String, #to_s] value
    # @param  [Hash{Symbol => Object}]      options
    # @return [Element]
    def format_literal(value, options = {})
      value = RDF::Literal.new(value) unless value.is_a?(RDF::Literal)
      case
        when value.datatype? # FIXME: use `has_datatype?` in RDF.rb 0.1.0
          create_element(:typedLiteral, value.value.to_s, 'datatype' => value.datatype.to_s)
        when value.language? # FIXME: use `has_language?` in RDF.rb 0.1.0
          create_element(:plainLiteral, value.value.to_s, 'xml:lang' => value.language.to_s)
        else
          create_element(:plainLiteral, value.value.to_s)
      end
    end

    ##
    # REXML implementation of the TriX writer.
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
        @xml = ::REXML::Document.new
        @xml << ::REXML::XMLDecl.new(::REXML::XMLDecl::DEFAULT_VERSION, @encoding)
      end

      ##
      # Generates the TriX root element.
      #
      # @return [void]
      def write_prologue
        @trix  = @xml.add_element('TriX', 'xmlns' => Format::XMLNS)
        @graph = @trix.add_element('graph')
      end

      ##
      # Outputs the TriX document.
      #
      # @return [void]
      def write_epilogue
        @xml.write(@output, @options[:indent] || 2)
        puts # add a line break after the last line
        @xml = @trix = @graph = nil
      end

      ##
      # Creates an XML comment element with the given `text`.
      #
      # @param  [String, #to_s] text
      # @return [REXML::Comment]
      def create_comment
        ::REXML::Comment.new(text.to_s)
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
      # @return [REXML::Element]
      def create_element(name, content = nil, attributes = {}, &block)
        element = @graph.add_element(name.to_s)
        attributes.each { |k, v| element.add_attribute(k.to_s, v) }
        element.add_text(content) unless content.nil?
        block.call(element) if block_given?
        element
      end
    end # module REXML

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
      def create_comment
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
        element.content = content unless content.nil?
        block.call(element) if block_given?
        element
      end
    end # module Nokogiri
  end # class Writer
end # module RDF::TriX
