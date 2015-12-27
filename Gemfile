source "https://rubygems.org"

gemspec

gem 'rdf',        git: "git://github.com/ruby-rdf/rdf.git", branch: "develop"
gem 'rdf-spec',   git: "git://github.com/ruby-rdf/rdf-spec.git", branch: "develop"

group :development do
  gem 'rdf-turtle',   git: "git://github.com/ruby-rdf/rdf-turtle.git", branch: "develop"
  gem "wirble"
  gem "syntax"
  gem "byebug", platform: :mri
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
end
