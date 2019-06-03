FROM openjdk:8-jre-alpine

WORKDIR /build

# Versions of things
ARG asciidoctor_version=2.0.9
ARG asciidoctor_confluence_version=0.0.2
ARG asciidoctor_pdf_version=1.5.0.alpha.17
ARG asciidoctor_diagram_version=1.5.16
ARG asciidoctor_epub3_version=1.5.0.alpha.9
ARG asciidoctor_mathematical_version=0.3.0
ARG asciidoctor_revealjs_version=2.0.0
ARG redoc_cli_version=0.8.4

ENV ASCIIDOCTOR_VERSION=${asciidoctor_version} \
  ASCIIDOCTOR_CONFLUENCE_VERSION=${asciidoctor_confluence_version} \
  ASCIIDOCTOR_PDF_VERSION=${asciidoctor_pdf_version} \
  ASCIIDOCTOR_DIAGRAM_VERSION=${asciidoctor_diagram_version} \
  ASCIIDOCTOR_EPUB3_VERSION=${asciidoctor_epub3_version} \
  ASCIIDOCTOR_MATHEMATICAL_VERSION=${asciidoctor_mathematical_version} \
  ASCIIDOCTOR_REVEALJS_VERSION=${asciidoctor_revealjs_version} \
  REDOC_CLI_VERSION=${redoc_cli_version}

# Installing package required for the runtime of
# any of the asciidoctor-* functionnalities
RUN apk add --no-cache \
    bash \
    curl \
    ca-certificates \
    findutils \
    font-bakoma-ttf \
    graphviz \
    inotify-tools \
    make \
    openjdk8-jre \
    py2-pillow \
    py-setuptools \
    python2 \
    ruby \
    nodejs \
    nodejs-npm \
    ruby-mathematical \
    ttf-liberation \
    unzip \
    which \
    wget

# Installing swagger2markup into ./bin/
RUN mkdir bin/ && mkdir tmp/
RUN update-ca-certificates && wget https://jcenter.bintray.com/io/github/swagger2markup/swagger2markup-cli/1.3.3/swagger2markup-cli-1.3.3.jar -O ./bin/swagger2markup.jar
ENV JAVA_OPTS="-Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# Installing Ruby Gems needed in the image
# including asciidoctor itself
RUN apk add --no-cache --virtual .rubymakedepends \
    build-base \
    libxml2-dev \
    ruby-dev \
  && gem install --no-document \
    "asciidoctor:${ASCIIDOCTOR_VERSION}" \
    "asciidoctor-confluence:${ASCIIDOCTOR_CONFLUENCE_VERSION}" \
    "asciidoctor-diagram:${ASCIIDOCTOR_DIAGRAM_VERSION}" \
    "asciidoctor-epub3:${ASCIIDOCTOR_EPUB3_VERSION}" \
    "asciidoctor-mathematical:${ASCIIDOCTOR_MATHEMATICAL_VERSION}" \
    asciimath \
    "asciidoctor-pdf:${ASCIIDOCTOR_PDF_VERSION}" \
    "asciidoctor-revealjs:${ASCIIDOCTOR_REVEALJS_VERSION}" \
    coderay \
    epubcheck:3.0.1 \
    haml \
    kindlegen:3.0.3 \
    pygments.rb \
    rake \
    rouge \
    slim \
    thread_safe \
    tilt \
  && apk del -r --no-cache .rubymakedepends

# Installing Python dependencies for additional
# functionnalities as diagrams or syntax highligthing
RUN apk add --no-cache --virtual .pythonmakedepends \
    build-base \
    python2-dev \
    py2-pip \
  && pip install --upgrade pip \
  && pip install --no-cache-dir \
    actdiag \
    'blockdiag[pdf]' \
    nwdiag \
    Pygments \
    seqdiag \
  && apk del -r --no-cache .pythonmakedepends

# Installing nodejs dependencies for OpenAPI UI generation
RUN npm install -g "redoc-cli@${REDOC_CLI_VERSION}"

ADD ./build-all.sh ./build-single-adoc.sh ./build-single-mxgraph.sh ./build-single-openapi.sh ./mxgraph_asciidoc_ext.rb ./

RUN apk add vim

VOLUME ["/build/input", "/build/output"]
ENTRYPOINT ["./build-all.sh"]
