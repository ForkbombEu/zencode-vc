all:
	@rm -f src/*
	@bats/bin/bats sign*bats
	@bats/bin/bats verify*bats

check:
	bats/bin/bats test.bats

deps:
	mise self-update
	mise install aqua:dyne/slangroom-exec@latest
	mise use aqua:dyne/slangroom-exec@latest
	eval `mise env`
