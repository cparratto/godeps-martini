FROM ubuntu

ENV GOLANG_VERSION="1.6.2" \
    GOLANG_DOWNLOAD_URL="http://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz" \
    GOLANG_DOWNLOAD_SHA256="e40c36ae71756198478624ed1bb4ce17597b3c19d243f3f0899bb5740d56212a" \
    GOPATH="/app" \
    PATH="PATH $GOPATH/bin:/usr/local/go/bin:$PATH"

RUN mkdir -p /app
WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl g++ gcc libc6-dev make && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz  \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c -  \
    && tar -C /usr/local -xzf golang.tar.gz  \
    && rm golang.tar.gz
RUN mkdir -p "$GOPATH/src" "$GOPATH/src/app" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
COPY . $GOPATH/src/app
RUN go install -v "$GOPATH/src/app"