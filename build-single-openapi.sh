#!/bin/bash
set -Eeuo pipefail

generate_redoc_file () {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*resources/}"
  local file_suffix=redoc.html

  local output="./docs/$file_base.$file_suffix"
  echo "Building: $full_file_path -> $output"

  redoc-cli bundle \
    --output "$output" \
    $full_file_path
}

generate_html_and_pdf() {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*resources/}"
  local temp_file_suffix=adoc

  # TODO: swagger2markup doesn't work for openapi v3, find/make an alternative
  if [[ $full_file_path == *.openapi.yml ]]; then
    return
  fi


  local temp_file_output="./tmp/$file_base"
  local temp_file_path="./tmp/$file_base.$temp_file_suffix"
  echo "Building: $full_file_path -> $temp_file_path"

  java -jar ./bin/swagger2markup.jar convert \
    -f $temp_file_output \
    -i $full_file_path

  # HACK: insert ":last-update-label!:" into the second line
  # of the adoc files using vim in "ex" mode to remove
  # the datestamp in the footer that always changes
  ex -sc '2i|:last-update-label!:' -cx $temp_file_path

  generate_pdf_from_temp $temp_file_path
  generate_html_from_temp $temp_file_path
}

generate_pdf_from_temp () {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*tmp/}"
  local file_suffix=pdf

  local output="./docs/$file_base.doc.$file_suffix"
  echo "Building: $full_file_path -> $output"

  asciidoctor \
    -r asciidoctor-diagram \
    -r asciidoctor-pdf \
    -b pdf \
    -o "$output" \
    $full_file_path
}

generate_html_from_temp () {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*tmp/}"
  local file_suffix=html

  local output="./docs/$file_base.doc.$file_suffix"
  echo "Building: $full_file_path -> $output"

  asciidoctor \
    -r asciidoctor-diagram \
    -r ./mxgraph_asciidoc_ext.rb \
    -b html5 \
    -a data-uri \
    -o "$output" \
    $full_file_path
}

generate_redoc_file $1

generate_html_and_pdf $1
