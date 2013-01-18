#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-trix'
  gem.homepage           = 'http://rdf.rubyforge.org/trix/'
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
  gem.requirements               = ['REXML (>= 3.1.7), LibXML-Ruby (>= 1.1.4), or Nokogiri (>= 1.4.4)']
  gem.add_runtime_dependency     'rdf',         '>= 0.3.3'
  gem.add_development_dependency 'rexml',       '>= 3.1.7'
  gem.add_development_dependency 'libxml-ruby', '>= 1.1.4'
  gem.add_development_dependency 'nokogiri',    '>= 1.4.4'
  gem.add_development_dependency 'yard' ,       '>= 0.6.7'
  gem.add_development_dependency 'rspec',       '>= 2.5.0'
  gem.add_development_dependency 'rdf-spec',    '>= 0.3.3'
  gem.post_install_message       = nil
end
