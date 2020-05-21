#!/bin/bash

oasis_core_root_path=$1

set -euo pipefail

# Download oasis-core binaries from a GitHub release.
download_oasis_core_artifacts() {
	local out_dir=$1

	oasis_core_version=$(cat OASIS_CORE_VERSION)

	mkdir -p "${out_dir}/go/oasis-node"
	mkdir -p "${out_dir}/go/oasis-net-runner"
	mkdir -p "${out_dir}/target/debug/"

	curl -L -o /tmp/oasis_core_linux_amd64.tar.gz \
		"https://github.com/oasislabs/oasis-core/releases/download/v${oasis_core_version}/oasis_core_${oasis_core_version}_linux_amd64.tar.gz"
	tar -C /tmp/ -xzf /tmp/oasis_core_linux_amd64.tar.gz

	mv /tmp/oasis-node "${out_dir}/go/oasis-node/"
	mv /tmp/oasis-net-runner "${out_dir}/go/oasis-net-runner/"
	mv /tmp/oasis-core-runtime-loader "${out_dir}/target/debug/"
}

download_oasis_core_artifacts $oasis_core_root_path
