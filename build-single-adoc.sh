#!/bin/bash
set -Eeuo pipefail

generate_pdf_file () {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*resources/}"
  local file_suffix=pdf

  local output="./docs/$file_base.$file_suffix"
  echo "Building: $full_file_path -> $output"

  asciidoctor \
    -r asciidoctor-diagram \
    -r asciidoctor-pdf \
    -b pdf \
    -o "$output" \
    $full_file_path
}

generate_html_file () {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*resources/}"
  local file_suffix=html

  local output="./docs/$file_base.$file_suffix"
  echo "Building: $full_file_path -> $output"

  asciidoctor \
    -r asciidoctor-diagram \
    -r ./mxgraph_asciidoc_ext.rb \
    -b html5 \
    -a data-uri \
    -o "$output" \
    $full_file_path
}

generate_pdf_file $1
generate_html_file $1
