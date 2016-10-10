#
# Copyright (c) 2013-2015 Richard Mortier <mort@cantab.net>
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright
# notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

MODE   ?= unix
DEPLOY ?= false

FS     ?=  # direct is implicit default until mirage#607 merged
NET    ?= socket
DHCP   ?= false

.PHONY: all configure build clean

all: build
	@ :

configure:
	mirage configure -f src/config.ml -t $(MODE) --net=$(NET) --dhcp=$(DHCP) \
	  # --kv_ro=$(FS)

build:
	@ [ -r src/Makefile ] \
	  && ( cd src && make ) \
	  || echo '"make configure" first!'

clean:
	[ -r src/Makefile ] && ( cd src && make clean ) || true
	mirage clean -f src/config.ml || true
	$(RM) log src/*.img
