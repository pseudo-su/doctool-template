#!/bin/bash
set -Eeuo pipefail

# Build Adoc's
find resources -type f -name '*.adoc' | xargs -L1 ./build-single-adoc.sh

# Build Redox's
find resources -type f -name '*.openapi.yml' | xargs -L1 ./build-single-openapi.sh

find resources -type f -name '*.swagger.yml' | xargs -L1 ./build-single-openapi.sh

# Build MxGraph's
find resources -type f -name '*.mxgraph.xml' | xargs -L1 ./build-single-mxgraph.sh
