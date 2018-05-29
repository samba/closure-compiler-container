FROM alpine:latest

ARG DATE=20180506

ENV DATE=${DATE}
ENV URL_TEMPLATE="http://dl.google.com/closure-compiler/compiler-${DATE}.tar.gz"

RUN apk add --no-cache openjdk8-jre wget 

RUN wget -O /tmp/closure.tar.gz  "${URL_TEMPLATE}" && \
    mkdir -p /tmp/closure/extract && \
    tar -xvf /tmp/closure.tar.gz -C /tmp/closure/extract && \
    rm -v /tmp/closure.tar.gz


COPY scripts/closure-compiler.sh /usr/local/bin/closure-compiler
RUN chmod +x /usr/local/bin/closure-compiler

ENTRYPOINT /usr/local/bin/closure-compiler
