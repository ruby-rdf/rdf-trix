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
  # [LibXML]:   http://libxml.rubyforge.org/rdoc/
  # [Nokogiri]: http://nokogiri.org/
  #
  # @example Obtaining a TriX writer class
  #   RDF::Writer.for(:trix)         #=> RDF::TriX::Writer
  #   RDF::Writer.for("etc/test.xml")
  #   RDF::Writer.for(:file_name      => "etc/test.xml")
  #   RDF::Writer.for(:file_extension => "xml")
  #   RDF::Writer.for(:content_type   => "application/trix")
  #
  # @example Instantiating a Nokogiri-based writer
  #   RDF::TriX::Writer.new(output, :library => :nokogiri)
  #
  # @example Instantiating a REXML-based writer
  #   RDF::TriX::Writer.new(output, :library => :rexml)
  #
  # @example Serializing RDF statements into a TriX file
  #   RDF::TriX::Writer.open("etc/test.xml") do |writer|
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
    # Returns the XML implementation module for this writer instance.
    #
    # @return [Module]
    attr_reader :implementation

    ##
    # Initializes the TriX writer instance.
    #
    # @param  [IO, File]               output
    # @param  [Hash{Symbol => Object}] options
    # @option options [Symbol]         :library  (:nokogiri or :rexml)
    # @option options [String, #to_s]  :encoding ('utf-8')
    # @option options [Integer]        :indent   (2)
    # @yield  [writer]
    # @yieldparam [Writer] writer
    def initialize(output = $stdout, options = {}, &block)
      @library = case options[:library]
        when nil
          # Use Nokogiri or LibXML when available, and REXML otherwise:
          begin
            require 'nokogiri'
            :nokogiri
          rescue LoadError => e
            begin
              require 'libxml'
              :rexml # FIXME: no LibXML support implemented yet
            rescue LoadError => e
              :rexml
            end
          end
        when :libxml then :rexml # FIXME
        when :nokogiri, :libxml, :rexml
          options[:library]
        else
          raise ArgumentError.new("expected :rexml, :libxml or :nokogiri, but got #{options[:library].inspect}")
      end

      require "rdf/trix/writer/#{@library}"
      @implementation = case @library
        when :nokogiri then Nokogiri
        when :libxml   then LibXML # TODO
        when :rexml    then REXML
      end
      self.extend(@implementation)

      @encoding = (options[:encoding] || 'utf-8').to_s
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
  end # class Writer
end # module RDF::TriX
