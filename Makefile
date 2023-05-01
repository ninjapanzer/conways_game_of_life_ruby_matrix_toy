SHELL := /bin/sh

run:
	@ruby life.rb

run-with-seed-and-dimensions:
	@ruby life.rb -s$(SEED) -d$(DIMENSIONS)

console:
	@bundle exec irb -r $(shell pwd)/requires.rb

test:

asdf-setup:
	asdf plugin add ruby || true
	asdf install ruby

init: asdf-setup
	@bundle config set --local path 'vendor/bundle' && bundle instal
	@bundle

.PHONY: init run run-with-seed-and-dimensions console test asdf-setup
