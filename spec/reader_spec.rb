require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::TriX::Reader do
  it "should be discoverable" do
    readers = [
      RDF::Reader.for(:trix),
      RDF::Reader.for("etc/doap.xml"),
      RDF::Reader.for(:file_name      => "etc/doap.xml"),
      RDF::Reader.for(:file_extension => "xml"),
      RDF::Reader.for(:content_type   => "application/trix"),
    ]
    readers.each { |reader| reader.should == RDF::TriX::Reader }
  end

  context "when parsing etc/doap.xml" do
    before :each do
      etc = File.expand_path(File.join(File.dirname(__FILE__), '..', 'etc'))
      @ntriples = RDF::NTriples::Reader.new(File.open(File.join(etc, 'doap.nt')))
      @reader = RDF::TriX::Reader.open(File.join(etc, 'doap.xml'))
    end

    it "should return the correct number of statements" do
      @reader.count.should == @ntriples.count
    end
  end
end
