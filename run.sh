#!/bin/sh

# check for existence of go
if ! which go; then
	echo "could not find golang binary" 1>&2
	exit 1
fi

# make govendor-sync directory in the cache
if [ ! -d "$WERCKER_CACHE_DIR"/govendor-sync ]; then
	mkdir -p "$WERCKER_CACHE_DIR"/govendor-sync/bin "$WERCKER_CACHE_DIR"/govendor-sync/vendor
fi

# install govendor or copy from cache
cp "$WERCKER_CACHE_DIR"/govendor-sync/bin/* "$GOPATH"/bin/

if ! which govendor; then
	go get -u github.com/kardianos/govendor
	cp -f "$GOPATH"/bin/govendor "$WERCKER_CACHE_DIR"/govendor-sync/bin/
fi

# check for existence of vendor.json
if [ ! -e vendor/vendor.json ]; then
	echo "could not find vendor.json" 1>&2
	exit 1
fi

# restore vendor cache and sync
cp -r "$WERCKER_CACHE_DIR"/govendor-sync/vendor/* vendor/

govendor sync

cp -r vendor/*/ "$WERCKER_CACHE_DIR"/govendor-sync/vendor/
