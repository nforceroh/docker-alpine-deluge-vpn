#!/usr/bin/make -f

SHELL := /bin/bash
IMG_NAME := d_alpine-deluge-vpn
IMG_REPO := nforceroh
VERSION := $(shell date +"v%Y%m%d" )

.PHONY: context all build push gitcommit gitpush
all: context build push 
git: context gitcommit gitpush

context: 
	@echo "Switching docker context to default"
	docker context use default

build:
	@ echo "Building $(IMG_NAME):$(VERSION) image"
	docker build --rm --tag=$(IMG_REPO)/$(IMG_NAME) .
	docker tag $(IMG_REPO)/$(IMG_NAME) $(IMG_REPO)/$(IMG_NAME):$(VERSION)
	docker tag $(IMG_REPO)/$(IMG_NAME) $(IMG_REPO)/$(IMG_NAME):latest

gitcommit:
	git push

gitpush:
	@ echo "Building $(IMG_NAME):$(VERSION) image"
	git tag -a $(VERSION) -m "Update to $(VERSION)"
	git push --tags

push:
	@ echo "Building $(IMG_NAME):$(VERSION) image"
	docker push $(IMG_REPO)/$(IMG_NAME):$(VERSION)
	docker push $(IMG_REPO)/$(IMG_NAME):latest

end:
	@echo "Done!"