.PHONY: spec docs examples

all: spec docs examples

spec:
	crystal spec -v

docs:
	crystal docs

examples:
	rm -rf bin
	rm -rf *.pdf
	shards build
	./bin/*
