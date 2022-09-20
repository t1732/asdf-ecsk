#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/t1732/ecsk"
TOOL_NAME="ecsk"
TOOL_TEST="ecsk -h"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if <YOUR TOOL> is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
  list_github_tags
}

checkout_tag() {
  local version
  version="$1"

  echo "* Checkout $TOOL_NAME release $version..."
  git clone --branch "v$version" --depth 1 --single-branch --recursive $GH_REPO "$ASDF_DOWNLOAD_PATH"
  rm -rf "$ASDF_DOWNLOAD_PATH"/.git
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports version installs only"
  fi

  (
    cd "$ASDF_DOWNLOAD_PATH"
    mkdir -p "$install_path"

    echo "build $TOOL_NAME $version..."
    go mod tidy
    CGO_ENABLED=0 GO111MODULE=on go build -ldflags '-s -w -X github.com/t1732/ecsk/pkg/cmd.Version=v${version}' -o "$install_path/ecsk" cmd/ecsk/main.go

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$ASDF_DOWNLOAD_PATH"
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
