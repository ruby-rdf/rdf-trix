#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-trix'
  gem.homepage           = 'http://ruby-rdf.github.com/rdf-trix'
  gem.license            = 'Unlicense'
  gem.summary            = 'TriX support for RDF.rb.'
  gem.description        = 'RDF.rb extension for parsing/serializing TriX data.'
  gem.rubyforge_project  = 'rdf'

  gem.author             = 'Arto Bendiken'
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README.md UNLICENSE VERSION etc/doap.xml) + Dir.glob('lib/**/*.rb')
  gem.bindir             = %q(bin)
  gem.executables        = %w()
  gem.default_executable = gem.executables.first
  gem.require_paths      = %w(lib)
  gem.extensions         = %w()
  gem.test_files         = %w()
  gem.has_rdoc           = false

  gem.required_ruby_version      = '>= 2.0'
  gem.add_runtime_dependency     'rdf',         '~> 2.0'
  gem.add_development_dependency 'rdf-spec',    '~> 2.0'
  gem.add_development_dependency 'rspec',       '~> 3.4'
  gem.add_development_dependency 'rspec-its',   '~> 1.2'
  gem.add_development_dependency 'yard' ,       '~> 0.8'
  gem.add_development_dependency 'nokogiri',    '~> 1.6'
  gem.add_development_dependency 'libxml-ruby', '~> 2.8' unless defined?(:RUBY_ENGINE) && RUBY_ENGINE == "jruby"

  gem.post_install_message       = nil
end
