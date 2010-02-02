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
    format RDF::TriX::Format

    # TODO
  end # class Writer
end # module RDF::TriX
