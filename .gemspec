#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

GEMSPEC = Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-trix'
  gem.homepage           = 'http://rdf.rubyforge.org/'
  gem.license            = 'Public Domain' if gem.respond_to?(:license=)
  gem.summary            = 'TriX support for RDF.rb.'
  gem.description        = 'RDF.rb plugin for parsing/serializing TriX data.'
  gem.rubyforge_project  = 'rdf'

  gem.authors            = ['Arto Bendiken']
  gem.email              = 'arto.bendiken@gmail.com'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS README UNLICENSE VERSION) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 1.8.2'
  gem.requirements               = []
  gem.add_development_dependency 'rspec',    '>= 1.2.9'
  gem.add_development_dependency 'yard' ,    '>= 0.5.3'
  gem.add_runtime_dependency     'rdf',      '>= 0.0.9'
  gem.add_runtime_dependency     'nokogiri', '>= 1.4.1'
  gem.post_install_message       = nil
end
