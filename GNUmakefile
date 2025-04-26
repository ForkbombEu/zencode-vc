.PHONY: docs

all:
	@rm -f src/*.json src/*.slang
	@bats/bin/bats mldsa-rdfc-2025.bats
	@bats/bin/bats eddsa-rdfc-2022.bats
	@bats/bin/bats ecdsa-rdfc-2019.bats

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
