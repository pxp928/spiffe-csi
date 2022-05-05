#!/bin/bash

set -e -o pipefail

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "Applying SPIFFE CSI Driver configuration..."
kubectl apply -f "$DIR"/config/spiffe-csi-driver.yaml

echo "Creating SPIRE namespace..."
kubectl apply -f "$DIR"/config/spire-namespace.yaml

echo "Deploying SPIRE server"
kubectl apply -f "$DIR"/config/spire-server.yaml
echo "Waiting for SPIRE Server to deploy..."
kubectl rollout status -n spire deployment/spire-server

echo "Deploying SPIRE agent"
kubectl apply -f "$DIR"/config/spire-agent.yaml
echo "Waiting for SPIRE Agent to deploy..."
kubectl rollout status -n spire daemonset/spire-agent

#echo "Deploying SPIRE Workload registrar"
#kubectl apply -f "$DIR"/config/spire-workload-registrar.yaml
#echo "Waiting for SPIRE Workload registrar to deploy..."
#kubectl rollout status -n spire deployment/spire-registrar

echo "Done."
