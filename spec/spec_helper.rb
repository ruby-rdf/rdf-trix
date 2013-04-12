$:.unshift(File.expand_path("../../lib", __FILE__))
require "bundler/setup"
require 'rspec'
require 'rdf/trix'
require 'rdf/spec'

RSpec.configure do |config|
  config.include(RDF::Spec::Matchers)
  config.exclusion_filter = {:ruby => lambda { |version|
    RUBY_VERSION.to_s !~ /^#{version}/
  }}
end
