# Define a BACKEND variable

PLATFORM := $(shell opam list --installed --short mirage-xen)
NET := $(shell opam list --installed --short mirage-net-socket)

ifeq ($(strip $(PLATFORM)),mirage-xen)
	BACKEND := --xen
else
	BACKEND := --unix
    ifeq ($(strip $(NET)),mirage-net-socket)
        BACKEND += --socket
    endif
endif

configure:
	cd src && mirari configure $(BACKEND)

fs: 
	mir-crunch -o src/filesystem_static.ml -name "static" ./files

clean:
	cd src && mirari clean
	$(RM) mir-www
	$(RM) src/main.ml src/backend.ml src/filesystem_static.ml
	$(RM) files/slides/oscon13/complete.html

build: configure fs
	cd src && mirari build $(BACKEND)

run: build
	cd src && mirari run $(BACKEND)

page-%:
	cd files/slides/$* \
	  && ln -sf ../../reveal-2.4.0/css \
	  && ln -sf ../../reveal-2.4.0/js \
	  && ln -sf ../../reveal-2.4.0/plugin \
	  && ln -sf ../../reveal-2.4.0/lib

	sed -E 's@(src="|href="|src: ")@\1/Users/mort/research/projects/mirage/src/v2/mirage-decks/files/reveal-2.4.0/@g' files/templates/reveal-2.4.0-header.html \
		>| files/slides/$*/complete.html \
	  && cat files/slides/$*/index.html \
		>> files/slides/$*/complete.html \
	  && sed -E 's@(src="|href="|src: ")@\1/Users/mort/research/projects/mirage/src/v2/mirage-decks/files/reveal-2.4.0/@g' files/templates/reveal-2.4.0-footer.html \
		>> files/slides/$*/complete.html
