.PHONY: spec docs examples

all: fmt lint spec docs examples

fmt:
	crystal tool format

spec:
	crystal spec -v

lint:
	./lib/ameba/bin/ameba

docs:
	crystal docs

examples: clean
	shards build
	sh ./examples/run.sh

clean:
	rm -rf bin
	rm -rf *.pdf
	rm -rf docs
