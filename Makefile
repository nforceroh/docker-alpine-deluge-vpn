#!/usr/bin/make -f

SHELL := /bin/bash
IMG_NAME := d_alpine-deluge-vpn
IMG_REPO := nforceroh
BUILD_TAG := $(shell date +"v%Y%m%d%H%M%S" )
VERSION := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ" )

.PHONY: context all build push gitcommit gitpush
all: context build push 
git: context gitcommit gitpush

context: 
	@echo "Switching docker context to default"
	docker context use default

build:
	@ echo "Building $(IMG_NAME):$(VERSION) image"
	docker buildx build --rm . \
		--build-arg BUILD_DATE="$(BUILD_DATE)" \
		--build-arg VCS_REF="$(VERSION)" \
		--build-arg BASE_IMAGE="nforceroh/d_alpine-s6:edge" \
		-t "$(IMG_REPO)/$(IMG_NAME)" \
		-t "$(IMG_REPO)/$(IMG_NAME):$(BUILD_TAG)" \
		-t "$(IMG_REPO)/$(IMG_NAME):latest"
#	TAGS=" -t $(IMG_REPO)/$(IMG_NAME) $(IMG_REPO)/$(IMG_NAME):$(BUILD_DATE) -t $(IMG_REPO)/$(IMG_NAME) $(IMG_REPO)/$(IMG_NAME):latest "

gitcommit:
	git push

gitpush:
	@ echo "Building $(IMG_NAME):$(BUILD_DATE) image"
	git tag -a $(BUILD_TAG) -m "Update to $(BUILD_TAG)"
	git push --tags

push:
	@ echo "Building $(IMG_NAME):$(VERSION) image"
	docker push $(IMG_REPO)/$(IMG_NAME):$(BUILD_TAG)
	docker push $(IMG_REPO)/$(IMG_NAME):latest

end:
	@echo "Done!"