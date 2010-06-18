require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::TriX::Format do
  it "should be discoverable" do
    formats = [
      RDF::Format.for(:trix),
      RDF::Format.for("etc/doap.xml"),
      RDF::Format.for(:file_name      => "etc/doap.xml"),
      RDF::Format.for(:file_extension => "xml"),
      RDF::Format.for(:content_type   => "application/trix"),
    ]
    formats.each { |format| format.should == RDF::TriX::Format }
  end
end
