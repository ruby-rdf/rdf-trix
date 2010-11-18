TriX Support for RDF.rb
=======================

This is an [RDF.rb][] plugin that adds support for parsing/serializing
[TriX][], an XML-based RDF serialization format developed by HP Labs and
Nokia.

* <http://github.com/bendiken/rdf-trix>
* <http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby>

Documentation
-------------

* {RDF::TriX}
  * {RDF::TriX::Format}
  * {RDF::TriX::Reader}
  * {RDF::TriX::Writer}

Dependencies
------------

* [RDF.rb](http://rubygems.org/gems/rdf) (>= 0.3.0)
* [REXML](http://ruby-doc.org/stdlib/libdoc/rexml/rdoc/) (>= 3.1.7),
  [LibXML-Ruby](http://rubygems.org/gems/libxml-ruby) (>= 1.1.4), or
  [Nokogiri](http://rubygems.org/gems/nokogiri) (>= 1.4.2)

Installation
------------

The recommended installation method is via [RubyGems](http://rubygems.org/).
To install the latest official release of the `RDF::TriX` gem, do:

    % [sudo] gem install rdf-trix

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf-trix.git

Alternatively, download the latest development version as a tarball as
follows:

    % wget http://github.com/bendiken/rdf-trix/tarball/master

Mailing List
------------

* <http://lists.w3.org/Archives/Public/public-rdf-ruby/>

Author
------

* [Arto Bendiken](http://github.com/bendiken) - <http://ar.to/>

Contributors
------------

Refer to the accompanying {file:CREDITS} file.

License
-------

This is free and unencumbered public domain software. For more information,
see <http://unlicense.org/> or the accompanying {file:UNLICENSE} file.

[RDF.rb]:   http://rdf.rubyforge.org/
[TriX]:     http://www.w3.org/2004/03/trix/
