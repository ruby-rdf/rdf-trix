#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-trix'
  gem.homepage           = 'http://ruby-rdf.github.com/rdf-trix'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'TriX support for RDF.rb.'
  gem.description        = 'RDF.rb plugin for parsing/serializing TriX data.'
  gem.rubyforge_project  = 'rdf'

  gem.author             = 'Arto Bendiken'
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README UNLICENSE VERSION etc/doap.xml) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.1'
  gem.requirements               = ['REXML (>= 3.1.7), LibXML-Ruby (>= 1.1.4), or Nokogiri (>= 1.4.2)']
  gem.add_runtime_dependency     'rdf',         '>= 1.0'
  gem.add_development_dependency 'rdf-spec',    '>= 1.0'
  gem.add_development_dependency 'rspec',       '>= 2.13'
  gem.add_development_dependency 'yard' ,       '>= 0.8.5'
  gem.add_development_dependency 'libxml-ruby', '>= 1.1.4' unless RUBY_PLATFORM == 'java'
  gem.add_development_dependency 'nokogiri',    '>= 1.5.9' unless RUBY_PLATFORM == 'java'
  gem.post_install_message       = nil
end
