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
pwd
echo .

for f in ${BASE_DIR}/k8s/templates/*.yaml ;
    do
    envsubst < $f > ${BASE_DIR}/k8s/deploy/${f##*/} ;
    echo "Processing $f -> ${BASE_DIR}/k8s/deploy/${f##*/} ";
done

popd


