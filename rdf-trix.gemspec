#!/usr/bin/env ruby -rubygems
# -*- encoding: utf-8 -*-

is_java = RUBY_PLATFORM == 'java'

Gem::Specification.new do |gem|
  gem.version            = File.read('VERSION').chomp
  gem.date               = File.mtime('VERSION').strftime('%Y-%m-%d')

  gem.name               = 'rdf-trix'
  gem.homepage           = 'https://github.com/ruby-rdf/rdf-trix'
  gem.license            = 'Unlicense'
  gem.summary            = 'TriX support for RDF.rb.'
  gem.description        = 'RDF.rb extension for parsing/serializing TriX data.'
  gem.metadata           = {
    "documentation_uri" => "https://ruby-rdf.github.io/rdf-trix",
    "bug_tracker_uri"   => "https://github.com/ruby-rdf/rdf-trix/issues",
    "homepage_uri"      => "https://github.com/ruby-rdf/rdf-trix",
    "mailing_list_uri"  => "https://lists.w3.org/Archives/Public/public-rdf-ruby/",
    "source_code_uri"   => "https://github.com/ruby-rdf/rdf-trix",
  }

  gem.author             = 'Arto Bendiken'
  gem.email              = 'public-rdf-ruby@w3.org'

  gem.platform           = Gem::Platform::RUBY
  gem.files              = %w(AUTHORS CREDITS README.md UNLICENSE VERSION etc/doap.xml) + Dir.glob('lib/**/*.rb')
  gem.require_paths      = %w(lib)

  gem.required_ruby_version      = '>= 2.6'
  gem.add_runtime_dependency     'rdf',               '~> 3.2'
  gem.add_runtime_dependency     'rdf-xsd',           '~> 3.2'
  gem.add_development_dependency 'rdf-spec',          '~> 3.2'
  gem.add_development_dependency 'rdf-trig',          '~> 3.2'
  gem.add_development_dependency 'rdf-ordered-repo',  '~> 3.2'
  gem.add_development_dependency 'rspec',             '~> 3.10'
  gem.add_development_dependency 'rspec-its',         '~> 1.3'
  gem.add_development_dependency 'yard' ,             '~> 0.9'
  gem.add_development_dependency 'nokogiri',          '~> 1.10' # 1.12 Ruby >= 2.5
  gem.add_development_dependency 'libxml-ruby',       '~> 3.2' unless is_java

  gem.post_install_message       = nil
end
