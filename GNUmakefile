.PHONY: docs

define genbat
	$(info Generating ${1} W3C VC RDFC )
	@cat rdfc-vc.tmpl \
	| zencode_algo=${1} zencode_scenario=${2} \
		envsubst '$$zencode_algo $$zencode_scenario' \
	> ${1}-rdfc.bats
	bats/bin/bats ${1}-rdfc.bats
endef

all: clean genpages

genpages:
	@bats/bin/bats mldsa44-rdfc.bats
	@bats/bin/bats es256-rdfc.bats
	@bats/bin/bats eddsa-rdfc.bats

genbats: # manually triggered, will overwrite slight modifications
	$(call genbat,mldsa44,qp)
	$(call genbat,es256,es256)
	$(call genbat,eddsa,eddsa)

check:
	bats/bin/bats test.bats

deps:
	@mise self-update
	@mise install
	@npm i
	@eval `mise env`

dev:
	@npm run docs:dev

docs:
	@npm run docs:build

clean:
	@rm -f src/*exec_log.md
	@rm -f src/*json src/*svg src/*slang src/*dot
