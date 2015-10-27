#!/usr/bin/env ruby

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

desc "Generate etc/doap.xml from etc/doap.ttl."
task :doap do
  $:.unshift(File.expand_path("../lib", __FILE__))
  require "bundler/setup"
  require 'rubygems'
  require 'rdf/turtle'
  require 'rdf/trix'
  RDF::TriX::Writer.open("etc/doap.xml") do |writer|
    RDF::Turtle::Reader.open("etc/doap.ttl") do |reader|
      reader.each_statement { |statement| writer << statement }
    end
  end
end
