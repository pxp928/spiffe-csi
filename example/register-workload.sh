#!/bin/bash

set -e -o pipefail

DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


###################################################################
# Caution:
#
# This script registers the example workload with SPIRE so that it can obtain
# an SVID from the SPIFFE Workload API. Specifically, it creates an entry that
# groups all agents in the cluster and then registers any workload running in
# the default namespace against that group, effectively granting any workload
# in the default namespace the specified SPIFFE ID.
#
# These registrations for demonstrative purposes only and DO NOT reflect
# best practices for registering workloads inside of Kubernetes.
#
###################################################################

echo "Registering node..."
kubectl exec -it \
    -n spire \
    deployment/spire-server -- \
    /opt/spire/bin/spire-server entry create \
        -node \
        -spiffeID spiffe://example.org/node \
        -selector k8s_psat:cluster:example-cluster

echo "Registering Tekton Pipeline Controller..."
kubectl exec -it \
    -n spire \
    deployment/spire-server -- \
    /opt/spire/bin/spire-server entry create \
        -parentID spiffe://example.org/node \
        -spiffeID spiffe://example.org/workload/tekton-controller \
        -selector k8s:ns:tekton-pipelines \
        -selector k8s:pod-label:app:tekton-pipelines-controller \
        -selector k8s:sa:tekton-pipelines-controller \
        -admin

echo "Registering Tekton Chains Controller..."
kubectl exec -it \
    -n spire \
    deployment/spire-server -- \
    /opt/spire/bin/spire-server entry create \
        -parentID spiffe://example.org/node \
        -spiffeID spiffe://example.org/workload/tekton-chains-controller \
        -selector k8s:ns:tekton-chains \
        -selector k8s:pod-label:app:tekton-chains-controller \
        -selector k8s:sa:tekton-chains-controller

echo "Done."
