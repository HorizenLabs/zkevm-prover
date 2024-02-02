#!/bin/bash

PATCH_NAME=$(printf "%q" "$1")
if [ -z "$PATCH_NAME" ]; then
	echo "Please provide a valid patch name"
	exit
fi
cd prover_src/zkevm-prover 
PATCH_TMP_FILE=.tmp_patch
git diff HEAD > $PATCH_TMP_FILE
if [ ! -s $PATCH_TMP_FILE ]; then
	echo "No change to build a patch"
	rm $PATCH_TMP_FILE
	exit
fi
COUNT_PATCHES=0
for filename in ../../patches/[0-9][0-9][0-9]_*.patch; do
        let COUNT_PATCHES=COUNT_PATCHES+1
done
FILENAME=$(printf "%03d\n" $(( COUNT_PATCHES+1 )))_$PATCH_NAME.patch
mv $PATCH_TMP_FILE ../../patches/$FILENAME
