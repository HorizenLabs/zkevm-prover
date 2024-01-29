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
PATCHES_TO_APPLY=1000
if [ ! -z $1 ]; then
	let PATCHES_TO_APPLY=$(($1))
fi
COUNT_PATCHES=0
for filename in ../../patches/[0-9][0-9][0-9]_*.patch; do
	if [ "$COUNT_PATCHES" -ge "$PATCHES_TO_APPLY" ]; then
		echo "skipping after applying $COUNT_PATCHES patches"
		break 
	fi
	git apply $filename
	let COUNT_PATCHES=COUNT_PATCHES+1
	git add .
	for file in $(git diff --name-only HEAD); do
		if [[ "$file" =~ \.proto$ ]]; then
			generate_proto_sources
			break
		fi 
	done
	git -c user.name="John Doe" -c user.email="johndoe@gmail.com" commit -m "Apply patch $(basename -s .patch $filename)" -a
done
