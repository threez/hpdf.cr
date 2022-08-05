.PHONY: spec docs examples

all: lint spec docs examples

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