require File.join(File.dirname(__FILE__), 'spec_helper')

describe 'RDF::TriX::VERSION' do
  it "should match the VERSION file" do
    RDF::TriX::VERSION.to_s.should == File.read(File.join(File.dirname(__FILE__), '..', 'VERSION')).chomp
  end
end
