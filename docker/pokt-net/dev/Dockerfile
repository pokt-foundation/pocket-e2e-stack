# This Dockerfile attempts to install dependencies, run the tests and build the pocket-core binary
# The result of this Dockerfile will put the pocket-core executable in the $GOBIN/bin, which in turn
# is part of the $PATH

# Dynamically pull Go-lang version for the image
ARG GOLANG_IMAGE_VERSION=golang:1.16.2-alpine3.13

# First build step to build the app binary
FROM ${GOLANG_IMAGE_VERSION} AS builder

# Install dependencies
RUN apk -v --update --no-cache add \
	curl \
	git \
	groff \
	less \
	mailcap \
	gcc \
	libc-dev \
	bash  \
	leveldb-dev && \
	rm /var/cache/apk/* || true

# Environment and system dependencies setup
ENV POCKET_PATH=/go/src/github.com/pokt-network/pocket-core/
ENV GO111MODULE="on"
ENV EXECCOMMAND="start --keybase=false --datadir=/home/app/.pocket"
ENV POCKET_CORE_SEEDS="notparsed"
ENV POCKET_CORE_KEY="nokeyisparsed"
ENV POCKET_CORE_ACCOUNT_ADDRESS="noaddressisparsed"

# Create node root directory
RUN mkdir -p ${POCKET_PATH}
WORKDIR $POCKET_PATH

# Creating the BRANCH_NAME variable
ARG BRANCH_NAME="staging"

# Install rest of source code
COPY . .

# Copying deps and hot reloading/watch script
COPY install-deps.sh ./deps.sh
COPY watch.sh ./
COPY entrypoint-dev.sh /tmp/
COPY command.sh /tmp/

# Run tests
# As the tests were removed recently for the fact that most of them were broken, I commented this line,
# It should be uncommented as soon as the new tests are available.
#RUN go test ./tests/...
RUN apk add --update --no-cache expect bash leveldb-dev build-base
RUN addgroup -S app \
	&& adduser -S -G app app
RUN mv /tmp/entrypoint-dev.sh /home/app/entrypoint.sh && mv /tmp/command.sh /home/app/command.sh
RUN mkdir -p /home/app/.pocket/config
RUN chown -R app /home/app/.pocket

# Install project dependencies and builds the binary
RUN go build -tags cleveldb -o ${GOBIN}/bin/pocket ./app/cmd/pocket_core/main.go

# install reflex and dlv
RUN go get github.com/cespare/reflex
RUN go get github.com/go-delve/delve/cmd/dlv@latest

USER app
ENTRYPOINT ["/home/app/entrypoint.sh"]
