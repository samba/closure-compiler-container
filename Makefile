


TAG_COMMIT := $(shell git rev-list  --tags --max-count=1 --abbrev-commit HEAD)
TAG := $(shell git describe --abbrev=0 --tags ${TAG_COMMIT} 2>/dev/null || true)
COMMIT := $(shell git rev-parse --short HEAD)
DATE := $(shell git log -1 --format=%cd --date=short)
VERSION := $(TAG:v%=%)
ifneq ($(COMMIT), $(TAG_COMMIT))
    VERSION := $(VERSION)-next-$(COMMIT)-$(DATE)
endif
ifeq ($(VERSION),)
    VERSION := $(COMMIT)-$(DATA)
endif
ifneq ($(shell git status --porcelain),)
    VERSION := $(VERSION)-dirty
endif


IMAGE_NAME=closure-compiler

ifeq ($(VERSION),master)
IMAGE_TAG=latest
else
IMAGE_TAG=$(VERSION)
endif


.cache:
	mkdir -p .cache

.PHONY: build
build: .cache/build
.cache/build: Dockerfile $(shell find ./scripts/ -type f) | .cache
	docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} --compress .
	echo "${IMAGE_NAME}:${IMAGE_TAG}" > $@

.PHONY: test
test: .cache/build
	docker run -it --rm ${IMAGE_NAME}:${IMAGE_TAG} --version | grep 'Version:'

.PHONY: clean
clean:
	docker rmi ${IMAGE_NAME}:${IMAGE_TAG}
	rm -f .cache/build
