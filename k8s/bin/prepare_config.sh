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
export KUBE_APP_CONFIG=kafka-client
export KUBE_CLUSTER=kubernetes-p8-integrations-eu-dev-2
export KUBE_REGION=europe-west3

export DOLLAR='$'
pushd ${BASE_DIR}

echo .
pwd
echo .

for f in ${BASE_DIR}/k8s/templates/*.yaml ;
    do
    envsubst < $f > ${BASE_DIR}/k8s/deploy/${f##*/} ;
    echo "Processing $f -> ${BASE_DIR}/k8s/deploy/${f##*/} ";
done


cat << EOF > ${BASE_DIR}/src/main/resources/application.yaml
#Info endpoints
info:
  company: Dexcom
  project: integrations

# Management endpoints
management:
  endpoint:
    restart:
      enabled:  true

spring:
  application:
    name: ${KUBE_APP_NAME}
  cloud:
    kubernetes:
      config:
        name: ${KUBE_APP_NAME}
        namespace: ${KUBE_NAMESPACE}
        sources:
          - name: ${KUBE_APP_CONFIG}
      reload:
        enabled: true
        mode: polling
        period: 2000
# Actuator endpoints
endpoints:
  cors:
    allowed-origins: "*"
  metrics:
    enabled: true
  configprops:
    enabled: true
  env:
    enabled: true
  beans:
    enabled: true

EOF


cat << EOF > ${BASE_DIR}/cloudbuild.yaml
substitutions:
  _DEXCOM_PROJECT_ID: ${KUBE_APP_NAME}
  _DEXCOM_NAMESPACE: ${KUBE_NAMESPACE}
images:
  - "gcr.io/${DOLLAR}PROJECT_ID/${DOLLAR}{_DEXCOM_PROJECT_ID}:${DOLLAR}REVISION_ID"
steps:
  - name: 'gcr.io/cloud-builders/mvn'
    args: ['install']
  - name: 'gcr.io/cloud-builders/docker'
    args: ['build', '--tag=gcr.io/${DOLLAR}PROJECT_ID/${DOLLAR}{_DEXCOM_PROJECT_ID}:${DOLLAR}REVISION_ID', '.']
  - name: 'gcr.io/cloud-builders/docker'
    args: ["push", "gcr.io/${DOLLAR}PROJECT_ID/${DOLLAR}{_DEXCOM_PROJECT_ID}:${DOLLAR}REVISION_ID"]
  - name: 'gcr.io/cloud-builders/kubectl'
    args:
      - 'set'
      - 'image'
      - 'deployment/${DOLLAR}{_DEXCOM_PROJECT_ID}-dep'
      - 'spring-boot-container=gcr.io/${DOLLAR}PROJECT_ID/${DOLLAR}{_DEXCOM_PROJECT_ID}:${DOLLAR}REVISION_ID'
      - '--namespace=${DOLLAR}{_DEXCOM_NAMESPACE}'
    env:
      - 'CLOUDSDK_COMPUTE_ZONE=${KUBE_REGION}'
      - 'CLOUDSDK_CONTAINER_CLUSTER=${KUBE_CLUSTER}'
EOF

popd

