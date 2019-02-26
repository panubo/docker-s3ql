TAG      := 3.0
IMAGE    := panubo/s3ql
REGISTRY := docker.io

build:
	docker build --pull -t $(IMAGE):$(TAG) .

run:
	docker run --rm -it --privileged $(IMAGE):$(TAG)

shell:
	docker run --rm -it --entrypoint bash --privileged $(IMAGE):$(TAG)

push:
	docker tag $(IMAGE):$(TAG) $(REGISTRY)/$(IMAGE):$(TAG)
	docker push $(REGISTRY)/$(IMAGE):$(TAG)
