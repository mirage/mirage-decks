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

test: unix-socket-build unix-socket-run

fs: 
	mir-crunch -o src/filesystem_static.ml -name "static" ./files

xen-%:
	$(MAKE) FLAGS=--xen $*

unix-socket-%:
	$(MAKE) FLAGS="--unix --socket" $*

unix-direct-%:
	$(MAKE) FLAGS="--unix" $*
