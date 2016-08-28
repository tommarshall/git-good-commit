setup:
	@rm -rf vendor
	@mkdir -p vendor
	git clone --depth 1 git://github.com/sstephenson/bats.git     vendor/bats
	git clone --depth 1 git://github.com/ztombol/bats-assert.git  vendor/bats-assert
	git clone --depth 1 git://github.com/ztombol/bats-support.git vendor/bats-support

test:
	vendor/bats/bin/bats test

.PHONY: setup test
