#!/bin/bash
set -Eeuo pipefail

if [ -d "./docs" ]; then
  rm -r ./docs
fi

mkdir -p ./docs
