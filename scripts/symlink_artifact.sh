#!/bin/bash

src_path=$1
binary_path=$2
root_path=$3

set -euo pipefail

# Symlink an artifact from the source directory to the root directory.
symlink_artifact() {
    local src_path=$1
    local binary_path=$2
    local root_path=$3
    local skip_sanity_check=${4:-"0"}

    local artifact_src_path="$(realpath -m "${src_path}/${binary_path}")"
    local artifact_dst_path="${root_path}/${binary_path}"

    # Sanity check the source artifact.
    if [[ "${skip_sanity_check}" != "1" && ! -f "${artifact_src_path}" ]]; then
        echo "ERROR: Artifact '${binary_path}' does not exist in specified path ${src_path}."
        echo "       Maybe you need to run: make -C \"${src_path}\""
        exit 1
    fi

    mkdir -p "$(dirname "${artifact_dst_path}")"
    ln -sf "${artifact_src_path}" "${artifact_dst_path}"
}

symlink_artifact $root_path $binary_path $src_path 1
