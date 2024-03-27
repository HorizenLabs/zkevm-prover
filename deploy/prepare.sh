#!/bin/bash

set -e

# Load envirorments

. ../.env

docker build -t hl/zkevm-prover:${TAG} ../prover_src/zkevm-prover

FORK_CFG_URL=${FORK_CFG_URL:-"https://storage.googleapis.com/zkevm/zkproverc/v3.0.0-RC3-fork.6.tgz"}
filename=$(basename -- "$FORK_CFG_URL")
folder="${filename%.*}"

if [ ! -d ${folder} ] ; then
	tmp=`mktemp -d`
	tmp_tar="${tmp}/archive.tgz"

	curl -o ${tmp_tar} ${FORK_CFG_URL}

	tar xvf ${tmp_tar}
fi

rm -rf config
ln -s ${folder}/config config
