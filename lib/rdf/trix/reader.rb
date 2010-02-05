module RDF::TriX
  ##
  # TriX parser.
  #
  # @example Obtaining a TriX reader class
  #   RDF::Reader.for(:trix)         #=> RDF::TriX::Reader
  #   RDF::Reader.for("spec/data/test.xml")
  #   RDF::Reader.for(:file_name      => "spec/data/test.xml")
  #   RDF::Reader.for(:file_extension => "xml")
  #   RDF::Reader.for(:content_type   => "application/trix") 
  #
  # @example Parsing RDF statements from a TriX file
  #   RDF::TriX::Reader.open("spec/data/test.xml") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from a TriX string
  #   data = StringIO.new(File.read("spec/data/test.xml"))
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
    # Initializes the TriX reader instance.
    #
    # @param  [IO, File, String] input
    # @param  [Hash{Symbol => Object}] options
    # @yield  [reader]
    # @yieldparam [Reader] reader
    def initialize(input = $stdin, options = {}, &block)
      super do
        self.extend case options[:library]
          when :rexml    then REXML
          when :nokogiri then Nokogiri
          else Nokogiri # FIXME: REXML # the safe default
        end
        initialize_xml
        block.call(self) if block_given?
      end
    end

    ##
    # REXML implementation of the TriX reader.
    #
    # @see http://www.germane-software.com/software/rexml/
    module REXML
      ##
      # Initializes the underlying XML library.
      #
      # @return [void]
      def initialize_xml
        require 'rexml/document' unless defined?(::REXML)
        # TODO
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
        # TODO
      end
    end

    ##
    # Nokogiri implementation of the TriX reader.
    #
    # @see http://nokogiri.org/
    module Nokogiri
      ##
      # Initializes the underlying XML library.
      #
      # @return [void]
      def initialize_xml
        require 'nokogiri' unless defined?(::Nokogiri)
        @xml = ::Nokogiri::XML(@input.read)
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
            triple = triple.children.select { |value| value.element? }
            triple = triple.map { |element| parse_element(element.name, element, element.content) }
            block.call(*triple)
          end
        end
      end
    end

    ##
    # Returns the RDF value of the given TriX element.
    #
    # @param  [String] name
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
  end # class Reader
end # module RDF::TriX
