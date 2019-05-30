#!/bin/bash

export BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." >/dev/null 2>&1 && pwd )"

#project_config_file="project_config.yaml"
#
#if [ ! -f ${BASE_DIR}/${project_config_file} ]; then
#    echo "Project config file ${project_config_file} missing in current directory"
#    exit 0
#fi
#
#echo .
#echo "Bootstraping kubernetes project artifacts"
#echo .

export KUBE_NAMESPACE=germany
export KUBE_APP_NAME=spring-ajar

pushd ${BASE_DIR}

echo .
echo Creating kubernetes objects
echo .


kubectl apply -f ./k8s/deploy/namespace.yaml
kubectl apply -f ./k8s/deploy/config-map.yaml
kubectl apply -f ./k8s/deploy/role.yaml
kubectl apply -f ./k8s/deploy/replica-set.yaml
kubectl apply -f ./k8s/deploy/svc.yaml

popd


