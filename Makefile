.PHONY: spec docs examples

all: lint spec docs examples

spec:
	crystal spec -v

lint:
	./bin/ameba

docs:
	crystal docs

examples: clean
	shards build
	./bin/*

clean:
	rm -rf bin
	rm -rf *.pdf