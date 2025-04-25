.PHONY: docs

all:
	@rm -f src/*.json src/*.slang
	@bats/bin/bats sign*bats
	@bats/bin/bats verify*bats

check:
	bats/bin/bats test.bats

deps:
	@mise self-update
	@mise install aqua:dyne/slangroom-exec@latest
	@mise use aqua:dyne/slangroom-exec@latest
	@npm i
	@eval `mise env`

docs:
	@npm run docs:build
