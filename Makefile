REPO						= merveturhan/intel_sgx
TAG_LATEST			= latest
TAG_NATIVE			= native
TAG_SGX					= sgx
TAG_SANCUS			= sancus

TAG							?= sgx

ifeq ($(TAG), latest)
DOCKERFILE 			= Dockerfile
else
DOCKERFILE			= Dockerfile_$(TAG)
endif

push_all:
	make push TAG=$(TAG_SGX)

pull_all:
	make pull TAG=$(TAG_SGX)

build:
	docker build -t $(REPO):$(TAG) --build-arg DUMMY2=$(shell date +%s) -f $(DOCKERFILE) .

push: build login
	docker push $(REPO):$(TAG)

pull:
	docker pull $(REPO):$(TAG)

run: check_workspace
	docker run --rm -it --network=host -v $(WORKSPACE):/usr/src/app/ -v /var/run/aesmd/:/var/run/aesmd $(REPO):$(TAG) bash

login:
	docker login

clean:
	docker rm $(shell docker ps -a -q) 2> /dev/null || true
	docker image prune -f

check_workspace:
	@test $(WORKSPACE) || (echo "WORKSPACE variable not defined. Run make <target> WORKSPACE=<path_to_project>" && return 1)
