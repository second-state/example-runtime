#!/bin/bash

set -euo pipefail

# For automatic cleanup on exit.
source ./scripts/common.sh

# Oasis core binaries.
oasis_node="${OASIS_CORE_ROOT_PATH}/go/oasis-node/oasis-node"
oasis_runner="${OASIS_CORE_ROOT_PATH}/go/oasis-net-runner/oasis-net-runner"
runtime_loader="${OASIS_CORE_ROOT_PATH}/target/default/debug/oasis-core-runtime-loader"
keymanager_binary="${OASIS_CORE_ROOT_PATH}/target/default/debug/oasis-core-keymanager-runtime"

# Runtime and test client binaries.
runtime_binary="${RUNTIME_CARGO_TARGET_DIR}/debug/example-runtime"
test_client="${RUNTIME_CARGO_TARGET_DIR}/debug/test-client"

# Prepare an empty data directory.
data_dir="/var/tmp/example-runtime-runner"
rm -rf "${data_dir}"
mkdir -p "${data_dir}"
chmod -R go-rwx "${data_dir}"
client_socket="${data_dir}/net-runner/network/client-0/internal.sock"

# Run the network.
echo "Starting the test network."
${oasis_runner} \
    --net.node.binary ${oasis_node} \
    --net.runtime.binary ${runtime_binary} \
    --net.runtime.loader ${runtime_loader} \
    --net.keymanager.binary ${keymanager_binary} \
    --net.epochtime_mock \
    --basedir.no_temp_dir \
    --basedir ${data_dir} &

# Wait for the validator node to be registered.
echo "Waiting for the validator node to be registered."
${oasis_node} debug control wait-nodes \
    --address unix:${client_socket} \
    --nodes 2 \
    --wait

# Advance epoch.
echo "Advancing epoch."
${oasis_node} debug control set-epoch \
    --address unix:${client_socket} \
    --epoch 1

# Wait for all nodes to be registered.
echo "Waiting for all nodes to be registered."
${oasis_node} debug control wait-nodes \
    --address unix:${client_socket} \
    --nodes 6 \
    --wait

# Advance epoch.
echo "Advancing epoch."
${oasis_node} debug control set-epoch \
    --address unix:${client_socket} \
    --epoch 2

# Start the test client.
echo "Starting the test client"
${test_client} \
    --node-address unix:${client_socket} \
    --runtime-id 8000000000000000000000000000000000000000000000000000000000000000
