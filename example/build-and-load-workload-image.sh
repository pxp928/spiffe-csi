#!/bin/bash

set -e -o pipefail

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Building the example workload image..."
docker build "$DIR"/workload -t ppatel1989/spiffe-csi-driver-example-workload:example
docker push ppatel1989/spiffe-csi-driver-example-workload:example

echo "Done."
