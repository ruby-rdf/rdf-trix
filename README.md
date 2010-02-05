TriX Support for RDF.rb
=======================

This is an [RDF.rb][] plugin that adds support for parsing/serializing the
XML-based [TriX][] serialization format developed by HP Labs and Nokia.

* <http://github.com/bendiken/rdf-trix>

Documentation
-------------

* {RDF::TriX}
  * {RDF::TriX::Format}
  * {RDF::TriX::Reader}
  * {RDF::TriX::Writer}

Dependencies
------------

* [RDF.rb](http://gemcutter.org/gems/rdf) (>= 0.0.9)
* [REXML](http://ruby-doc.org/stdlib/libdoc/rexml/rdoc/) (>= 3.1.7) or
  [Nokogiri](http://gemcutter.org/gems/nokogiri) (>= 1.4.1)

Installation
------------

The recommended installation method is via RubyGems. To install the latest
official release from Gemcutter, do:

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

[RDF.rb]: http://rdf.rubyforge.org/
[TriX]:   http://www.w3.org/2004/03/trix/
