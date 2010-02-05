module RDF::TriX
  ##
  # TriX parser.
  #
  # This class supports both [REXML][] and [Nokogiri][] for XML processing,
  # and will automatically select the most performant implementation
  # (Nokogiri) when it is available. If need be, you can explicitly
  # override the used implementation by passing in a `:library` option to
  # `Reader.new` or `Reader.open`.
  #
  # [REXML]:    http://www.germane-software.com/software/rexml/
  # [Nokogiri]: http://nokogiri.org/
  #
  # @example Obtaining a TriX reader class
  #   RDF::Reader.for(:trix)         #=> RDF::TriX::Reader
  #   RDF::Reader.for("spec/data/test.xml")
  #   RDF::Reader.for(:file_name      => "spec/data/test.xml")
  #   RDF::Reader.for(:file_extension => "xml")
  #   RDF::Reader.for(:content_type   => "application/trix")
  #
  # @example Instantiating a REXML-based reader
  #   RDF::TriX::Reader.new(input, :library => :rexml)
  #
  # @example Instantiating a Nokogiri-based reader
  #   RDF::TriX::Reader.new(input, :library => :nokogiri)
  #
  # @example Parsing RDF statements from a TriX file
  #   RDF::TriX::Reader.open("spec/data/examples.xml") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from a TriX string
  #   data = StringIO.new(File.read("spec/data/examples.xml"))
  #   RDF::TriX::Reader.new(data) do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @see http://www.w3.org/2004/03/trix/
  class Reader < RDF::Reader
    format RDF::TriX::Format

    ##
    # Returns the XML implementation module for this reader instance.
    #
    # @return [Module]
    attr_reader :implementation

    ##
    # Initializes the TriX reader instance.
    #
    # @param  [IO, File, String]       input
    # @param  [Hash{Symbol => Object}] options
    # @option options [Symbol]         :library (:rexml or :nokogiri)
    # @yield  [reader]
    # @yieldparam [Reader] reader
    def initialize(input = $stdin, options = {}, &block)
      super do
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
        block.call(self) if block_given?
      end
    end

    ##
    # Returns the RDF value of the given TriX element.
    #
    # @param  [String]                 name
    # @param  [Hash{String => Object}] attributes
    # @param  [String] content
    # @return [RDF::Value]
    def parse_element(name, attributes, content)
      case name.to_sym
        when :id
          RDF::Node.new(content.strip)
        when :uri
          RDF::URI.new(content.strip)
        when :typedLiteral
          RDF::Literal.new(content, :datatype => attributes['datatype'])
        when :plainLiteral
          if lang = attributes['xml:lang'] || attributes['lang']
            RDF::Literal.new(content, :language => lang)
          else
            RDF::Literal.new(content)
          end
        else
          # TODO: raise error
      end
    end

    ##
    # REXML implementation of the TriX reader.
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
        @xml = ::REXML::Document.new(@input, :compress_whitespace => %w{uri})
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
        @xml.elements.each('TriX/graph/triple') do |triple|
          triple = triple.select { |node| node.kind_of?(::REXML::Element) }[0..2]
          triple = triple.map { |element| parse_element(element.name, element.attributes, element.text) }
          block.call(*triple)
        end
      end
    end # module REXML

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
