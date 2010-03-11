require File.join(File.dirname(__FILE__), 'spec_helper')

describe RDF::TriX::Reader do
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

describe RDF::TriX::Writer do
  # TODO
end
