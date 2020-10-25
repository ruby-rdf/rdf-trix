TriX Support for RDF.rb
=======================

This is an [RDF.rb][] extension that adds support for parsing/serializing
[TriX][], an XML-based RDF serialization format developed by HP Labs and
Nokia.

* <https://github.com/ruby-rdf/rdf-trix>

[![Gem Version](https://badge.fury.io/rb/rdf-trix.png)](https://badge.fury.io/rb/rdf-trix)
[![Build Status](https://travis-ci.org/ruby-rdf/rdf-trix.png?branch=master)](https://travis-ci.org/ruby-rdf/rdf-trix)

Documentation
-------------

* {RDF::TriX}
  * {RDF::TriX::Format}
  * {RDF::TriX::Reader}
  * {RDF::TriX::Writer}

Dependencies
------------

* [RDF.rb](https://rubygems.org/gems/rdf) (~> 3.1)
  [Nokogiri](https://rubygems.org/gems/nokogiri) (>= 1.10.0)

Installation
------------

The recommended installation method is via [RubyGems](https://rubygems.org/).
To install the latest official release of the `RDF::TriX` gem, do:

    % [sudo] gem install rdf-trix

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/ruby-rdf/rdf-trix.git

Alternatively, download the latest development version as a tarball as
follows:

    % wget https://github.com/ruby-rdf/rdf-trix/tarball/master

Mailing List
------------

* <https://lists.w3.org/Archives/Public/public-rdf-ruby/>

Author
------

* [Arto Bendiken](https://github.com/artob) - <https://ar.to/>

Contributors
------------

Refer to the accompanying {file:CREDITS} file.

## Contributing

This repository uses [Git Flow](https://github.com/nvie/gitflow) to mange development and release activity. All submissions _must_ be on a feature branch based on the _develop_ branch to ease staging and integration.

* Do your best to adhere to the existing coding conventions and idioms.
* Don't use hard tabs, and don't leave trailing whitespace on any line.
  Before committing, run `git diff --check` to make sure of this.
* Do document every method you add using [YARD][] annotations. Read the
  [tutorial][YARD-GS] or just look at the existing code for examples.
* Don't touch the `.gemspec` or `VERSION` files. If you need to change them,
  do so on your private branch only.
* Do feel free to add yourself to the `CREDITS` file and the
  corresponding list in the the `README`. Alphabetical order applies.
* Don't touch the `AUTHORS` file. If your contributions are significant
  enough, be assured we will eventually add you in there.
* Do note that in order for us to merge any non-trivial changes (as a rule
  of thumb, additions larger than about 15 lines of code), we need an
  explicit [public domain dedication][PDD] on record from you,
  which you will be asked to agree to on the first commit to a repo within the organization.
  Note that the agreement applies to all repos in the [Ruby RDF](https://github.com/ruby-rdf/) organization.

## License

This is free and unencumbered public domain software. For more information,
see <https://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[RDF.rb]:   https://rubygems.org/gems/rdf/
[TriX]:     https://www.w3.org/2004/03/trix/
[PDD]:              https://unlicense.org/#unlicensing-contributions
