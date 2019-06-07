NAME := s3ql
TAG := latest
IMAGE := panubo/$(NAME)
REGISTRY := docker.io

.PHONY: help build push clean test run shell

help:
	@printf "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)\n"

build: ## Builds Docker image latest
	docker build --pull -t $(IMAGE):latest .

push: ## Pushes the Docker image to registry
	# Don't --pull here, we don't want any last minute upstream changes
	docker build -t $(IMAGE):$(TAG) .
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest
	docker push $(IMAGE):$(TAG)
	docker push $(IMAGE):latest

clean: ## Remove built images
	docker rmi $(IMAGE):latest
	docker rmi $(IMAGE):$(TAG)

test: ## Run tests
	@printf "Warning: No tests defined"

run: ## Run container
	docker run --rm -it --privileged $(IMAGE):latest

shell: ## Run container shell
	docker run --rm -it --entrypoint bash --privileged $(IMAGE):latest
