module RDF::TriX
  ##
  # TriX parser.
  #
  # This class supports [REXML][], [LibXML][] and [Nokogiri][] for XML
  # processing, and will automatically select the most performant
  # implementation (Nokogiri or LibXML) that is available. If need be, you
  # can explicitly override the used implementation by passing in a
  # `:library` option to `Reader.new` or `Reader.open`.
  #
  # [REXML]:    http://www.germane-software.com/software/rexml/
  # [LibXML]:   http://libxml.rubyforge.org/rdoc/
  # [Nokogiri]: http://nokogiri.org/
  #
  # @example Obtaining a TriX reader class
  #   RDF::Reader.for(:trix)         #=> RDF::TriX::Reader
  #   RDF::Reader.for("etc/doap.xml")
  #   RDF::Reader.for(:file_name      => "etc/doap.xml")
  #   RDF::Reader.for(:file_extension => "xml")
  #   RDF::Reader.for(:content_type   => "application/trix")
  #
  # @example Instantiating a Nokogiri-based reader
  #   RDF::TriX::Reader.new(input, :library => :nokogiri)
  #
  # @example Instantiating a LibXML-based reader
  #   RDF::TriX::Reader.new(input, :library => :libxml)
  #
  # @example Instantiating a REXML-based reader
  #   RDF::TriX::Reader.new(input, :library => :rexml)
  #
  # @example Parsing RDF statements from a TriX file
  #   RDF::TriX::Reader.open("etc/doap.xml") do |reader|
  #     reader.each_statement do |statement|
  #       puts statement.inspect
  #     end
  #   end
  #
  # @example Parsing RDF statements from a TriX string
  #   data = StringIO.new(File.read("etc/doap.xml"))
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
    # @option options [Symbol]         :library (:nokogiri, :libxml, or :rexml)
    # @yield  [reader]
    # @yieldparam [Reader] reader
    def initialize(input = $stdin, options = {}, &block)
      super do
        @library = case options[:library]
          when nil
            # Use Nokogiri or LibXML when available, and REXML otherwise:
            begin
              require 'nokogiri'
              :nokogiri
            rescue LoadError => e
              begin
                require 'libxml'
                :libxml
              rescue LoadError => e
                :rexml
              end
            end
          when :nokogiri, :libxml, :rexml
            options[:library]
          else
            raise ArgumentError.new("expected :rexml, :libxml or :nokogiri, but got #{options[:library].inspect}")
        end

        require "rdf/trix/reader/#{@library}"
        @implementation = case @library
          when :nokogiri then Nokogiri
          when :libxml   then LibXML
          when :rexml    then REXML
        end
        self.extend(@implementation)

        initialize_xml(options)
        block.call(self) if block_given?
      end
    end

    ##
    # @private
    # @see RDF::Reader#each_triple
    def each_triple(&block)
      unless block_given?
        enum_for(:each_triple)
      else
        each_statement do |statement|
          block.call(*statement.to_triple)
        end
      end
    end

    ##
    # @private
    # @see RDF::Reader#each_quad
    def each_quad(&block)
      unless block_given?
        enum_for(:each_quad)
      else
        each_statement do |statement|
          block.call(*statement.to_quad)
        end
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
  end # class Reader
end # module RDF::TriX
