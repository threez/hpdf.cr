.PHONY: spec docs examples

all: clean fmt lint docs spec examples montage.png

fmt:
	crystal tool format

spec:
	crystal spec -v

lint:
	./lib/ameba/bin/ameba

docs:
	crystal docs

examples:
	shards build
	sh ./examples/run.sh

pdfs/%.png: pdfs/%.pdf
	gs -dNOPAUSE -dBATCH -dQUIET -sDEVICE=png16m -sOutputFile=$@ -r144 $<

ALL_PDFS=$(shell find ./pdfs -type f | sed 's/pdf$$/png/')

montage.png: $(ALL_PDFS)
	montage $(shell find ./pdfs -type f -name "*.png") $@

clean:
	rm -rf bin
	rm -rf docs
	rm -rf pdfs/*.pdf
	rm -rf pdfs/*.png
