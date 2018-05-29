
IMAGE_NAME=closure-compiler
IMAGE_TAG=latest


build:
	docker build --no-cache -t ${IMAGE_NAME}:${IMAGE_TAG} --compress .

