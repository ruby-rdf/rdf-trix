require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::TriX::Writer do
  it "should be discoverable" do
    writers = [
      RDF::Writer.for(:trix),
      RDF::Writer.for("etc/test.xml"),
      RDF::Writer.for(:file_name      => "etc/test.xml"),
      RDF::Writer.for(:file_extension => "xml"),
      RDF::Writer.for(:content_type   => "application/trix"),
    ]
    writers.each { |writer| writer.should == RDF::TriX::Writer }
  end
end
