source "https://rubygems.org"

gemspec

gem 'rdf',      git: "https://github.com/ruby-rdf/rdf",       branch: "develop"
gem "nokogiri"

group :development do
  gem 'ebnf',               git: "https://github.com/dryruby/ebnf",               branch: "develop"
  gem 'json-ld',            git: "https://github.com/ruby-rdf/json-ld",           branch: "develop"
  gem 'rdf-isomorphic',     git: "https://github.com/ruby-rdf/rdf-isomorphic",    branch: "develop"
  gem 'rdf-spec',           git: "https://github.com/ruby-rdf/rdf-spec",          branch: "develop"
  gem 'rdf-turtle',         git: "https://github.com/ruby-rdf/rdf-turtle",        branch: "develop"
  gem 'rdf-ordered-repo',   git: "https://github.com/ruby-rdf/rdf-ordered-repo",  branch: "develop"
  gem 'sxp',                git: "https://github.com/dryruby/sxp.rb",             branch: "develop"
  gem "syntax"
  gem "byebug", platform: :mri
end

group :test do
  gem 'simplecov',      platforms: :mri
  gem 'coveralls',      '~> 0.8', platforms: :mri
end
