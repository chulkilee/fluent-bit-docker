FROM alpine:3.4
MAINTAINER Eduardo Silva <eduardo@treasure-data.com>
LABEL Description="Fluent Bit docker image" Vendor="Fluent Organization" Version="1.1"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
# therefore an 'apk delete build*' has no effect
RUN apk --no-cache --update add \
                            build-base \
                            ca-certificates \
                            cmake && \
    wget -O /tmp/fluent-bit-0.10.0.tar.gz http://fluentbit.io/releases/0.10/fluent-bit-0.10.0.tar.gz && \
    cd /tmp && tar zxfv fluent-bit-0.10.0.tar.gz && cd fluent-bit-0.10.0/build/ && \
    cmake -DFLB_DEBUG=On -DFLB_TRACE=On -DFLB_JEMALLOC=On ../ && \
    make && make install && \
    rm -rf /tmp/*

RUN adduser -D -g '' -u 1000 -h /home/fluent fluent
RUN chown -R fluent:fluent /home/fluent

# for log storage (maybe shared with host)
RUN mkdir -p /fluent-bit/log
# configuration/plugins path (default: copied from .)
RUN mkdir -p /fluent-bit/etc
RUN chown -R fluent:fluent /fluent-bit

USER fluent
WORKDIR /home/fluent

ENTRYPOINT ["sh"]
