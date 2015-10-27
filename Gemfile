source "https://rubygems.org"

gemspec

gem 'rdf',        git: "git://github.com/ruby-rdf/rdf.git", branch: "develop"
gem 'rdf-spec',   git: "git://github.com/ruby-rdf/rdf-spec.git", branch: "develop"

group :development do
  gem "wirble"
  gem "syntax"
  gem "byebug", platform: :mri_21
end

platforms :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubinius', '~> 2.0'
end
