#!/bin/bash

generate_proto_sources() {
	DOCKER_IMAGE=build-grpc
	docker build -t $DOCKER_IMAGE -f src/grpc/Dockerfile-GRPC .
	echo $(pwd)
	docker run --rm -v $(pwd)/src/grpc:/usr/src/app $DOCKER_IMAGE
	docker rmi $DOCKER_IMAGE 	
}

TAG=v2.2.0
mkdir -p prover_src
cd prover_src
if [ ! -d "zkevm-prover" ]; then
	git clone https://github.com/0xPolygonHermez/zkevm-prover.git
	cd zkevm-prover
	git submodule init
	git submodule update
else
	cd zkevm-prover
	git reset --hard tags/$TAG
fi
git checkout tags/$TAG
for filename in ../../patches/*.patch; do
	git apply $filename
	git add .
	for file in $(git diff --name-only HEAD); do
		if [[ "$file" =~ \.proto$ ]]; then
			generate_proto_sources
			break
		fi 
	done
	git commit -m "Apply patch $filename" -a
done 
