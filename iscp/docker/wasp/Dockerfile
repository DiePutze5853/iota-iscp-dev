ARG GOLANG_IMAGE_TAG=1.17-buster

# Build stage
FROM golang:${GOLANG_IMAGE_TAG} AS build
ARG BUILD_TAGS="rocksdb,builtin_static"
ARG BUILD_LD_FLAGS=""
ARG BUILD_TARGET="./..."
ARG BUILD_TARGET_CLI="./tools/wasp-cli"

WORKDIR /wasp

# Make sure that modules only get pulled when the module file has changed
COPY ./deps/wasp/go.mod ./deps/wasp/go.sum ./
RUN go mod download
RUN go mod verify

# Project build stage
COPY ./deps/wasp/ .

RUN go build -o . -tags=${BUILD_TAGS} -ldflags="${BUILD_LD_FLAGS}" ${BUILD_TARGET}
RUN go build -o . -tags=${BUILD_TAGS} -ldflags="${BUILD_LD_FLAGS}" ${BUILD_TARGET_CLI}

# Wasp build
FROM debian:stable-slim

RUN apt update; apt install jq curl netcat net-tools -y

ARG FINAL_BINARY="wasp"
ARG FINAL_BINARY_CLI="wasp-cli"

# WASP
EXPOSE 7000/tcp
EXPOSE 9090/tcp
EXPOSE 5550/tcp
EXPOSE 4000/udp

# EVM
EXPOSE 8545/tcp

COPY --from=build /wasp/${FINAL_BINARY} /usr/bin/
COPY --from=build /wasp/${FINAL_BINARY_CLI} /usr/bin/
COPY ./deps/wasp/docker_config.json /etc/wasp_config.json
COPY ./docker/wasp/start.sh /start.sh

CMD [ "/start.sh" ]
