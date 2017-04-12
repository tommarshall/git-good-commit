CURDIR:=$(shell pwd)

setup:
	@rm -rf vendor
	@mkdir -p vendor
	git clone --depth 1 git://github.com/sstephenson/bats.git     vendor/bats
	git clone --depth 1 git://github.com/ztombol/bats-assert.git  vendor/bats-assert
	git clone --depth 1 git://github.com/ztombol/bats-support.git vendor/bats-support

test:
	vendor/bats/bin/bats test

install:
	mkdir -p ~/.git-template/hooks
	git config --global init.templatedir '~/.git-template'
	cp -f hook.sh ~/.git-template/hooks/commit-msg

repair:
	find ~/ -name .git -type d -prune | xargs -I '{}' sh -c "[ ! -f '{}/hooks/commit-msg' ] && ln -s -f $(CURDIR)/hook.sh '{}/hooks/commit-msg' || true;"

.PHONY: setup test
