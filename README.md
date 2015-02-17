[![Build Status](https://travis-ci.org/mirage/mirage-decks.svg?branch=master)](https://travis-ci.org/mirage/mirage-decks)

These are the MirageOS slide decks, written as a self-hosting unikernel.

To view the content:

* [Install Mirage](http://www.openmirage.org/wiki/install)
* `make configure`
* `make build`

To test under a local unix, set `MODE=unix`, `NET=socket` and `PORT=8080` for
`mirage configure`, build, run as `./src/mir-decks`, and then navigate to
`http://127.0.0.1:8080` to view the slides.

To build for deployment on Xen, set `MODE=xen` for `mirage configure`.
