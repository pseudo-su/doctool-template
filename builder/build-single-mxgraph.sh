#!/bin/bash
set -Eeuo pipefail

# HACK: this seems like a massive hack, it's taken from https://github.com/jgraph/drawio/issues/150

# USAGE: build-drawio-single diagram.xml > diagram.html

# html encoding from https://stackoverflow.com/questions/12873682/#answer-12873723

generate_html_file () {
  local full_file_path=$1
  local file_base_a="${full_file_path%.*}"
  local file_base="${file_base_a#*input/}"
  local file_suffix=html

  local output="./output/$file_base.$file_suffix"
  echo "Building: $full_file_path -> $output"

diag="$(sed 's,.*<\(diagram [^>]*\)>\(.*\)<\(/diagram\)>.*,\1FOO\2BAR\3,g' <"$full_file_path"|\
  sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g'|\
  sed 's/&/\\&/g; s/FOO/\&gt;/; s/BAR/\&lt;/')"

test=$(cat <<EOF
<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=5,IE=9" ><![endif]-->
<!DOCTYPE html>
<html>
<head>
<title>diagram</title>
<meta charset="utf-8"/>
<style>
html, body, .geDiagramContainer {
  height: 100% !important;
  width: 100% !important;
  border: none;
  margin: 0;
  padding: 0;
  overflow: hidden;
}
.geDiagramContainer {
  overflow: auto !important;
}
</style>
</head>
<body><div class="mxgraph" style="max-width:100%;border:1px solid transparent;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;nav&quot;:true,&quot;resize&quot;:true,&quot;toolbar&quot;:&quot;zoom layers lightbox&quot;,&quot;edit&quot;:&quot;_blank&quot;,&quot;xml&quot;:&quot;&lt;mxfile userAgent=\&quot;Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.101 Safari/537.36\&quot; version=\&quot;7.3.5\&quot; editor=\&quot;www.draw.io\&quot; type=\&quot;device\&quot;&gt;&lt;$diag&gt;&lt;/mxfile&gt;&quot;}"></div>
<script type="text/javascript" src="https://www.draw.io/embed2.js?s=aws3;mscae/enterprise;gcp/networking;citrix&"></script>
</body>
</html>
EOF
)
  echo $test > $output
}

generate_html_file $1
