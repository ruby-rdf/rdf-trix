TriX Support for RDF.rb
=======================

This is an [RDF.rb][] plugin that adds support for parsing/serializing
[TriX][], an XML-based RDF serialization format developed by HP Labs and
Nokia.

* <http://github.com/bendiken/rdf-trix>

Documentation
-------------

* {RDF::TriX}
  * {RDF::TriX::Format}
  * {RDF::TriX::Reader}
  * {RDF::TriX::Writer}

Dependencies
------------

* [RDF.rb](http://rubygems.org/gems/rdf) (>= 0.1.0)
* [REXML](http://ruby-doc.org/stdlib/libdoc/rexml/rdoc/) (>= 3.1.7),
  [LibXML-Ruby](http://rubygems.org/gems/libxml-ruby) (>= 1.1.3), or
  [Nokogiri](http://rubygems.org/gems/nokogiri) (>= 1.4.1)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release, do:

    % [sudo] gem install rdf-trix

Download
--------

To get a local working copy of the development repository, do:

    % git clone git://github.com/bendiken/rdf-trix.git

Alternatively, you can download the latest development version as a tarball
as follows:

    % wget http://github.com/bendiken/rdf-trix/tarball/master

Author
------

* [Arto Bendiken](mailto:arto.bendiken@gmail.com) - <http://ar.to/>

License
-------

`RDF::TriX` is free and unencumbered public domain software. For more
information, see <http://unlicense.org/> or the accompanying UNLICENSE file.

[RDF.rb]:   http://rdf.rubyforge.org/
[TriX]:     http://www.w3.org/2004/03/trix/
