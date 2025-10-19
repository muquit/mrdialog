# Created Oct-18-2025 
VERSION := $(shell cat VERSION)

all: build doc

build:
	rm -rf pkg/*
	rake clean
	rake gemspec
	rake build
	cd pkg && sha256sum mrdialog-$(VERSION).gem > sha256sum.txt
	/bin/ls -lt ./pkg

# https://github.com/muquit/markdown-toc-go
doc:
	markdown-toc-go -i docs/README.md -o README.md -f
	markdown-toc-go -i docs/ChangeLog.md -o ChangeLog.md -f -no-credit

release: build
	gem push pkg/mrdialog-$(VERSION).gem

install: build
	gem install --local pkg/mrdialog-$(VERSION).gem

test-install: build
	gem install --local pkg/mrdialog-$(VERSION).gem
	ruby -e "require 'mrdialog'; puts 'mrdialog $(VERSION) installed successfully!'"

.PHONY: all build doc release install test-install
