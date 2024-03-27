# zkevm-prover

This repo contains the modifications necessary to run the Polygon ZKEVM prover in order to generate proofs for the New Horizen ecosystem.
The modifications are a set of patches that have to be subsequently applied to the source code of the Polygon ZKEVM prover [upstream repository](https://github.com/0xPolygonHermez/zkevm-prover).
This repository provides 2 scripts:

- `bootstrap.sh` to create a local copy of the upstream reposiotry and subsequently apply the patches, which are located in the `patches` folder
- `new_patch.sh` to generate a new patch from the modifications to the local copy of the upstream repository.

## Configuration

To change the fork-id reference please edit the `.env` file accordingly.

## Apply Existing Patches

Run the script `bootstrap.sh`. The script will create a local copy of the upstream repository in the `prover_src` folder. The script will fetch the upstream repository at a specific tag, which is specified as a variable in the `bootstrap.sh` script. After setting up a local copy of the upstream repository, the script will automatically apply all the patches found in the `patches` folder. Note that the filenames of such patches start with a sequence of 3 digits, which is employed to determine the order to follow when applying patches. It is possible to apply only the first `n` patches of this list by invoking the script as `./bootstrap.sh n`: for instance, the command `./bootstrap.sh 1` will apply only the first patch found in the `patches` folder.

## Create a New Patch

In case it is necessary to add further modifications to the Polygon ZKEVM prover, it is possible to rely on the `new_patch.sh` script as follows.

1. Run the script `./bootstrap.sh` to locally create in the `prover_src` folder the last version of the prover, that is the version with all the existing patches are applied to.
2. Modify the source files in `prover_src` as necessary; remember to run `git add <path-to-new-files>` in case you add new files to the prover
3. Run the script `new_patch.sh`, specifying as the first argument an identifier of the modifications that will be employed as the name of the patch file. This script will create a patch for the modifications to the source files and will save it in the `patches` folder. Note that the patch filename will be prefixed by 3 digits with the least available value depending on the number of existing patches, which is automatically computed by the script; therefore, it is recommended to always rely on the `new_patch.sh` script to add a new patch rather than copying it manually in the `patches` folder.

## Deploy

To deploy a new prover you can just go in the `deploy` folder, run the `./prepare.sh` script and start the docker compose image.

```bash
cd deploy
# Compile the prover and build the image
# Download the fork id dependencies (if they don't exist)
# Can need several minutes to complete these steps
./prepare.sh
docker compose up -d
```

An outdated but useful description of what these steps doing can be found in the https://docs.google.com/document/d/1Xwjuj3uOc1DcXk-g6e6N9wLRbDFFzv9eXQCzXYDO6Zw/edit#heading=h.s0vy9xy5gy0 document.
