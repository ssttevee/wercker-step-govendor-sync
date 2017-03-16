#!/bin/sh

# check for existence of go
if ! which go; then
	echo "could not find golang binary" 1>&2
	exit 1
fi

# make govendor-sync directory in the cache
if [ ! -d "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME" ]; then
	mkdir -p "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/bin "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/vendor
fi

# install govendor or copy from cache
if [ -e "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/bin/govendor ]; then
	cp "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/bin/govendor "$GOPATH"/bin/
fi

if ! which govendor; then
	go get -u github.com/kardianos/govendor
	cp -f "$GOPATH"/bin/govendor "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/bin/
fi

# check for existence of vendor.json
if [ ! -e vendor/vendor.json ]; then
	echo "could not find vendor.json" 1>&2
	exit 1
fi

# restore vendor cache and sync
if [ "$(ls -A "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/vendor/)" ]; then
	cp -r "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/vendor/* vendor/
fi

govendor sync

cp -r vendor/*/ "$WERCKER_CACHE_DIR"/"$WERCKER_STEP_NAME"/vendor/
