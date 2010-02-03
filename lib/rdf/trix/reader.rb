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
    format  RDF::TriX::Format
    include Nokogiri

    ##
    # Initializes the TriX reader instance.
    #
    # @param  [IO, File, String] input
    # @param  [Hash{Symbol => Object}] options
    # @yield  [reader]
    # @yieldparam [Reader] reader
    def initialize(input = $stdin, options = {}, &block)
      super do
        @xml = Nokogiri::XML(@input.read)
        block.call(self) if block_given?
      end
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
          triple = triple.map { |value| parse_value(value) }
          block.call(*triple)
        end
      end
    end

    ##
    # Returns the RDF value of the given TriX element.
    #
    # @param  [Nokogiri::XML::Element] element
    # @return [RDF::Value]
    def parse_value(element)
      case element.name.to_sym
        when :id
          RDF::Node.new(element.content.strip)
        when :uri
          RDF::URI.new(element.content.strip)
        when :typedLiteral
          RDF::Literal.new(element.content, :datatype => element[:datatype])
        when :plainLiteral
          if lang = element['lang']
            RDF::Literal.new(element.content, :language => lang)
          else
            RDF::Literal.new(element.content)
          end
        else
          # TODO: raise error
      end
    end
  end # class Reader
end # module RDF::TriX
