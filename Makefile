.PHONY: all clean fmt fmtcheck lint fix docs spec examples version tag libharu

LIBHARU_SRC   = vendor/libharu
LIBHARU_BUILD = vendor/libharu/build

all: clean fmt lint docs spec examples montage.png

libharu: ## Build static libharu from submodule if no system libhpdf >= 2.4.6 is found
	@if pkg-config --exists libhpdf 2>/dev/null && \
	   pkg-config --atleast-version=2.4.6 libhpdf 2>/dev/null; then \
	  echo "System libhpdf $$(pkg-config --modversion libhpdf) found, skipping submodule build."; \
	else \
	  echo "No suitable system libhpdf found, building from submodule..."; \
	  git submodule update --init $(LIBHARU_SRC); \
	  cmake -S $(LIBHARU_SRC) -B $(LIBHARU_BUILD) \
	    -DCMAKE_BUILD_TYPE=Release \
	    -DBUILD_SHARED_LIBS=OFF \
	    -DBUILD_TESTING=OFF; \
	  cmake --build $(LIBHARU_BUILD) --parallel; \
	fi

fmt:
	crystal tool format

fmtcheck:
	crystal tool format --check

spec:
	crystal spec -v

lib/ameba/bin/ameba:
	shards install

lint: lib/ameba/bin/ameba
	lib/ameba/bin/ameba

fix: lib/ameba/bin/ameba
	lib/ameba/bin/ameba --fix

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
	rm -rf docs/
	rm -rf pdfs/*.pdf
	rm -rf pdfs/*.png
	rm -rf $(LIBHARU_BUILD)

# Sync the VERSION constant in src/ to match shard.yml's version field.
# Bump shard.yml's version first, then run `make version`.
version:
	@V=$$(grep '^version:' shard.yml | sed -E 's/^version:[[:space:]]*//'); \
	for f in $$(grep -rl '^[[:space:]]*VERSION[[:space:]]*=[[:space:]]*"[^"]*"' src/ 2>/dev/null); do \
		sed -E "s/^([[:space:]]*VERSION[[:space:]]*=[[:space:]]*)\"[^\"]*\"/\\1\"$$V\"/" "$$f" > "$$f.tmp" && mv "$$f.tmp" "$$f"; \
		echo "updated $$f to $$V"; \
	done

# Create an annotated git tag "vX.Y.Z" from shard.yml's version field.
tag:
	@V=$$(grep '^version:' shard.yml | sed -E 's/^version:[[:space:]]*//'); \
	git tag -a "v$$V" -m "Release v$$V"; \
	echo "tagged v$$V"
