


TAG_COMMIT := $(shell git rev-list  --tags --max-count=1 --abbrev-commit HEAD)
TAG := $(shell git describe --abbrev=0 --tags ${TAG_COMMIT} 2>/dev/null || true)
COMMIT := $(shell git rev-parse --short HEAD)
BRIEF := $(shell git rev-parse --abbrev-ref HEAD)
DATE := $(shell git log -1 --format=%cd --date=short)
VERSION := $(TAG:v%=%)
ifneq ($(COMMIT), $(TAG_COMMIT))
    VERSION := $(VERSION)-$(BRIEF)-next-$(COMMIT)-$(DATE)
endif
ifeq ($(VERSION),)
    VERSION := $(COMMIT)-$(BRIEF)-$(DATE)
endif
ifneq ($(shell git status --porcelain),)
    VERSION := $(VERSION)-dirty
endif


IMAGE_NAME=closure-compiler
IMAGE_TAG=$(VERSION)


.cache:
	mkdir -p .cache



.PHONY: build
build: .cache/build
.cache/build: Dockerfile $(shell find ./scripts/ -type f) | .cache
	docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} --compress .
	echo "${IMAGE_NAME}:${IMAGE_TAG}" > $@
ifeq ($(VERSION),$(COMMIT)-master-$(DATE))
	docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest
endif

.PHONY: test
test: .cache/build
	docker run -it --rm ${IMAGE_NAME}:${IMAGE_TAG} --version | grep 'Version:'

.PHONY: clean
clean:
	docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true
	rm -f .cache/build
