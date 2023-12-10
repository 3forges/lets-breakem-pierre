#!/bin/bash


mkdir -p $HOME/docker/volumes/postgres
mkdir -p $HOME/.github


docker pull docker.redpanda.com/redpandadata/redpanda:v23.2.6
docker pull docker.redpanda.com/redpandadata/console:v2.3.1
docker pull docker.redpanda.com/redpandadata/redpanda:v23.2.6
docker pull minio/minio:RELEASE.2023-08-29T23-07-35Z
docker pull amazon/aws-cli
docker pull mageai/mageai:latest
docker pull jupyter/minimal-notebook:latest
docker pull postgres:13.3
docker pull hatmatrix/blog:base


echo "MYSQL_ROOT_PASSWORD=very_strong_password" > .secrets



export VM_IP_ADDR=$(ip addr | grep 168 | awk '{ print $2}' | awk -F '/' '{print $1}')

export VM_IP_ADRR=${VM_IP_ADRR:-"192.168.129.202"}
cat << EOF>./etc.hosts.de.addon
## DE
${VM_IP_ADRR}    mage.pesto.io
${VM_IP_ADRR}    redpanda-0.pesto.io
EOF

export OSYS=${OSYS:-"GNU/linux"}
if [ $OSYS == "windows" ]; then
  echo "OSYS= [${OSYS}]"
  cat ./etc.hosts.de.addon | tee -a /c/Windows/System32/drivers/etc/hosts
else
  echo "NIX system"
  cat ./etc.hosts.de.addon | tee -a /etc/hosts
fi;

# docker-compose -f docker-compose-infra-services.yml up --build
docker-compose -f docker-compose-infra-services.yml up

