# based off mirage-www/Makefile

.PHONY: all run clean test fs

all: build
	@ :

src/dist/setup:
	cd src && mirari configure www.conf $(FLAGS) $(CONF_FLAGS)

build: src/dist/setup
	cd src && mirari build www.conf $(FLAGS)

run:
	cd src && mirari run www.conf $(FLAGS)

clean:
	cd src && obuild clean
	$(RM) mir-www
	$(RM) src/main.ml src/backend.ml src/filesystem_static.ml

fs: 
	mir-crunch -o src/filesystem_static.ml -name "static" ./files

oscon13/complete:
	sed -E 's@(src="|href="|src: ")@\1/Users/mort/research/projects/mirage/src/v2/mirage-decks/files/reveal-2.4.0/@g' files/templates/reveal-2.4.0-header.html \
		>| files/slides/oscon13/complete.html \
	&& cat files/slides/oscon13/index.html \
		>> files/slides/oscon13/complete.html \
	&& sed -E 's@(src="|href="|src: ")@\1/Users/mort/research/projects/mirage/src/v2/mirage-decks/files/reveal-2.4.0/@g' files/templates/reveal-2.4.0-footer.html \
		>> files/slides/oscon13/complete.html


xen-%:
	$(MAKE) FLAGS=--xen $*

unix-socket-%:
	$(MAKE) FLAGS="--unix --socket" $*

unix-direct-%:
	$(MAKE) FLAGS="--unix" $*
