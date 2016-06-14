FROM alpine:edge
MAINTAINER Tobias Gesellchen <tobias@gesellix.de> (@gesellix)

EXPOSE 1313

ENV ARCHITECTURE linux_amd64
ENV HUGO_VERSION 0.15
ENV HUGO_BINARY hugo_${HUGO_VERSION}_${ARCHITECTURE}

RUN apk add --update curl git \
    && curl -sSL "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz" -o /tmp/hugo.tgz \
    && tar xfz /tmp/hugo.tgz -C /usr/local/ \
    && ln -s /usr/local/${HUGO_BINARY}/${HUGO_BINARY} /usr/local/bin/hugo \
    && rm /tmp/hugo.tgz \
    && rm -rf /var/cache/apk/*

RUN hugo new site /site \
    && cd /site \
    && hugo new post/index.md \
    && mkdir themes \
    && cd themes/ \
    && git clone https://github.com/keichi/vienna \
    && hugo version

ADD config.toml /site/config.toml

WORKDIR /site

ENV HUGO_BASEURL https://example.com

CMD hugo server --bind="0.0.0.0" --buildDrafts --theme=vienna
 
