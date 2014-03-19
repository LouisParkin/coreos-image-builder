#!/bin/bash
#
# docker_build.bash - Prepares and outputs a tarball'd docker repository
#                     suitable for injection into a coreos pxe image
#

set -e

OUTPUT_FILE="oem/container.tar.gz"

# If there's already a container.tar.gz, don't overwrite it -- instead, bail
if [[ -e "${OUTPUT_FILE}" ]]; then
  echo "${OUTPUT_FILE} already exists. Will not overwrite. Exiting."
  exit 1
fi

# Build the docker image
cd ../../ironic-python-agent
docker build -t oemdocker .
cd -

# Export the oemdocker repository to a tarball so it can be embedded in CoreOS
# TODO: Investigate running a container and using "export" to flatten the
#       image to shrink the CoreOS fs size. This will also require run.sh to
#       use docker import instead of docker load as well.
docker save oemdocker | gzip > ${OUTPUT_FILE}
