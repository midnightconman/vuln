#!/bin/sh

VERSION=${VERSION:-v0.0.0-20230224180816-edec1fb0a9c7}
ARCH=$( uname )

if [[ "$ARCH" == "Darwin" ]] ; then
  _COMMAND="shasum -a 256"
else
  _COMMAND="sha256sum"
fi

for os in linux darwin windows ; do
  for arch in amd64 arm64 ; do
    CGO_ENABLED=0 GOOS=$os GOARCH=$arch go build -ldflags="-extldflags=-static" -o govulncheck ./cmd/govulncheck
    tar czvf govulncheck-$VERSION.$os-$arch.tar.gz govulncheck
    $_COMMAND govulncheck-$VERSION.$os-$arch.tar.gz
    rm govulncheck
  done
done
