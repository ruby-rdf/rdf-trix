module RDF::TriX
  ##
  # TriX format specification.
  #
  # @example Obtaining a TriX format class
  #   RDF::Format.for(:trix)         #=> RDF::TriX::Format
  #   RDF::Format.for("spec/data/test.xml")
  #   RDF::Format.for(:file_name      => "spec/data/test.xml")
  #   RDF::Format.for(:file_extension => "xml")
  #   RDF::Format.for(:content_type   => "application/trix")
  #
  # @see http://www.w3.org/2004/03/trix/
  class Format < RDF::Format
    content_type     'application/trix', :extension => :xml
    content_encoding 'utf-8'

    reader { RDF::TriX::Reader }
    writer { RDF::TriX::Writer }

    require 'nokogiri'

    XMLNS = 'http://www.w3.org/2004/03/trix/trix-1/'
  end # class Format
end # module RDF::TriX
