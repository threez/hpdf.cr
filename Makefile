.PHONY: spec docs examples

all: spec docs examples

spec:
	crystal spec -v

docs:
	crystal docs

examples: clean
	shards build
	./bin/*

clean:
	rm -rf bin
	rm -rf *.pdf