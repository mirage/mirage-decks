[![Build Status](https://travis-ci.org/mirage/mirage-decks.svg?branch=master)](https://travis-ci.org/mirage/mirage-decks)

These are the MirageOS slide decks, written as a self-hosting unikernel.

To view the content locally:

* [Install Mirage](http://www.openmirage.org/wiki/install)
* `make configure`
* `make build`
* Run `sudo ./src/mir-decks` and point your browser to <http://localhost/>.

Set environment variables at the `configure` step to customise the build target
via `src/config.ml`:

+ `MODE`: `unix`, `xen`
+ `FS`: `direct`, `crunch`, `fat`
+ `DEPLOY`: `false`, `true`
+ `NET`: `socket`, `direct`
+ `DHCP`: `false`, `true`

Note that `DEPLOY=true` implies `NET=direct` and assumes `IP`, `NETMASK` and
`GATEWAYS` will be set.
