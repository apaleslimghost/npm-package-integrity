#!/bin/sh

set -e

readonly RESET="\e[0;0m"
readonly RED="\e[0;31m"
readonly GREEN="\e[0;32m"
readonly GREY="\e[0;90m"

readonly HR=${GREY}$(printf '─%.0s' $(seq 1 $(tput cols)))${RESET}

readonly OK="${GREEN}✓${RESET}"
readonly NO="${RED}✗${RESET}"

readonly PACKAGE='var p = require(process.cwd() + "/package.json");'
readonly NAME=$(node -pe "$PACKAGE p.name")
readonly VERSION=$(node -pe "$PACKAGE p.version")
readonly MAIN=$(node -pe "$PACKAGE p.main")
readonly TGZ="$(node -pe "$PACKAGE p.name.replace(/\//g, '-').replace(/^@/, '') + '-' + p.version + '.tgz'")"

echoe() {
	printf '%b\n' "$@"
}

hr() {
	echoe $HR
}

cleanup() {
	popd >/dev/null || {}
	rm -rf package "$TGZ"
}

npm_package_integrity() {
	npm pack >/dev/null
	tar -xf "$TGZ"
	pushd package >/dev/null

	ln -s ../node_modules node_modules
	if node -e 'require("./")'; then
		echoe "$OK ${GREY}$NAME@$VERSION${RESET} packaged ok"
	else
		hr
		echoe "$NO ${GREY}$NAME@$VERSION${RESET} package is broken! files in package:"
		ls .
		exit 1
	fi
}

trap cleanup EXIT

npm_package_integrity
