setup:
	@rm -rf vendor
	@mkdir -p vendor
	git clone --depth 1 https://github.com/bats-core/bats-core.git    vendor/bats
	git clone --depth 1 https://github.com/bats-core/bats-assert.git  vendor/bats-assert
	git clone --depth 1 https://github.com/bats-core/bats-support.git vendor/bats-support

test:
	vendor/bats/bin/bats test

.PHONY: setup test
