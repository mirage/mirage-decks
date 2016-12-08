[![Build Status](https://travis-ci.org/mirage/mirage-decks.svg?branch=master)](https://travis-ci.org/mirage/mirage-decks)

These are the MirageOS slide decks, written as a self-hosting unikernel.

To view the content locally:

* [Install Mirage](https://mirage.io/wiki/install)
* `make configure`
* `make build`
* Run `./src/mir-decksopenmirageorg` and point your browser to <http://localhost:8080/>.

Set environment variables at the `configure` step to customise the build target
via `src/config.ml`.  See `mirage configure -f src/config.ml --help` for details.
