#!/usr/bin/env ruby
require "bundler/setup"
require 'rdf/trix'
require 'rdf/turtle'
require 'rdf/ntriples'

namespace :gem do
  desc "Build the rdf-trix-#{File.read('VERSION').chomp}.gem file"
  task :build do
    sh "gem build rdf-trix.gemspec && mv rdf-trix-#{File.read('VERSION').chomp}.gem pkg/"
  end

  desc "Release the rdf-trix-#{File.read('VERSION').chomp}.gem file"
  task :release do
    sh "gem push pkg/rdf-trix-#{File.read('VERSION').chomp}.gem"
  end
end

desc "Generate etc/doap.nt from etc/doap.ttl."
task :doap => %w(etc/doap.xml etc/doap.nt)

file "etc/doap.xml" => "etc/doap.ttl" do
  RDF::TriX::Writer.open("etc/doap.xml") do |writer|
    RDF::Turtle::Reader.open("etc/doap.ttl") do |reader|
      reader.each_statement { |statement| writer << statement }
    end
  end
end

file "etc/doap.nt" => "etc/doap.ttl" do
  RDF::NTriples::Writer.open("etc/doap.nt") do |writer|
    RDF::Turtle::Reader.open("etc/doap.ttl") do |reader|
      reader.each_statement { |statement| writer << statement }
    end
  end
end
