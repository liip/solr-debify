solr Debian package generator (from the pre-built archive)
==========================================================

This is a Debian-package generator for solr.

It will generate a `.deb` package from the solr pre-built .tgz archive.

How to build a solr package
---------------------------

1. Make sure to have the following packages installed (from jessie-backports)
<pre>
    dpkg-dev (>= 1.17)
    debhelper (>= 9.20160403)
    dh-systemd
    devscripts (>= 2.16.4)
    quilt
</pre>

2. Download the latest version and prepare the build: run the following
   command from the `solr-build` directory:
<pre>
    $ ./debian/rules get-orig-source
</pre>

3. Apply the patches:
<pre>
    $ quilt push -af
</pre>

4. Build the binary package:
<pre>
    $ debuild -b
</pre>

LICENSE
-------

All that code is GPLv3+, Copyright 2016, Didier Raboud <odyx@liip.ch>.

solr itself is licensed under Apache-2.0 with exceptions, see solr-build/debian/copyright
