#!/bin/bash
set -Eeuo pipefail

# Build the builder docker image
docker build -t doctool-builder ./builder

PWD=$(pwd)
input="$PWD/resources"
output="$PWD/docs"

# Run the builder docker container to generate docs/ output
docker run \
  --mount type=bind,source=$input,target=/build/input \
  --mount type=bind,source=$output,target=/build/output \
  doctool-builder
