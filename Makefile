DOCKER_REGISTRY=035167628910.dkr.ecr.ap-southeast-1.amazonaws.com
DOCKER_NAME=libreoffice-unoserver
DOCKER_TAG=nightly
DOCKER_IMAGE=${DOCKER_REGISTRY}/${DOCKER_NAME}:${DOCKER_TAG}

build:
	docker build --pull --rm -f "Dockerfile" -t ${DOCKER_IMAGE} "."

push:
	docker push ${DOCKER_IMAGE}

run:
	docker run -it --rm \
		-v $(PWD)/data:/data \
		-p "2004:2004" \
		${DOCKER_IMAGE}

shell:
	docker run -it --rm \
		-v $(PWD)/data:/data \
		-p "2004:2004" \
		${DOCKER_IMAGE} sh
