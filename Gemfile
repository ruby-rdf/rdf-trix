source "https://rubygems.org"

gemspec

gem 'rdf',      github: "ruby-rdf/rdf",       branch: "develop"
gem "nokogiri"

group :development do
  gem 'ebnf',               github: "gkellogg/ebnf",                branch: "develop"
  gem 'json-ld',            github: "ruby-rdf/json-ld",             branch: "develop"
  gem 'rdf-isomorphic',     github: "ruby-rdf/rdf-isomorphic",      branch: "develop"
  gem 'rdf-spec',           github: "ruby-rdf/rdf-spec",            branch: "develop"
  gem 'rdf-turtle',         github: "ruby-rdf/rdf-turtle",          branch: "develop"
  gem 'sxp',                github: "gkellogg/sxp-ruby"
  gem "wirble"
  gem "syntax"
  gem "byebug", platform: :mri
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
end
