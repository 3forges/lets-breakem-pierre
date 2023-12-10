#!/bin/bash


mkdir -p $HOME/docker/volumes/postgres
mkdir -p $HOME/.github


echo "MYSQL_ROOT_PASSWORD=very_strong_password" > .secrets


export MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-"debezium"}
export MYSQL_USER=${MYSQL_USER:-"admin"}
export MYSQL_PASSWORD=${MYSQL_PASSWORD:-"admin123"}

cat << EOF>./.secrets
# MYSQL_ROOT_PASSWORD=very_strong_password
MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD}"
MYSQL_USER="${MYSQL_USER}"
MYSQL_PASSWORD="${MYSQL_PASSWORD}"
EOF

export VM_IP_ADDR=$(ip addr | grep 168 | awk '{ print $2}' | awk -F '/' '{print $1}')

export VM_IP_ADRR=${VM_IP_ADRR:-"192.168.129.202"}


export MINIO_ROOT_USER=${MINIO_ROOT_USER:-"minio"}
export MINIO_ROOT_PASSWORD=${MINIO_ROOT_PASSWORD:-"minio123"}
export MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY:-"minio"}
export MINIO_SECRET_KEY=${MINIO_SECRET_KEY:-"minio123"}

cat << EOF>./etc.hosts.de.addon
## DE
${VM_IP_ADRR}    mage.pesto.io
${VM_IP_ADRR}    redpanda-0.pesto.io
# MinIO
MINIO_ROOT_USER="${MINIO_ROOT_USER}"
MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD}"
MINIO_ACCESS_KEY="${MINIO_ACCESS_KEY}"
MINIO_SECRET_KEY="${MINIO_SECRET_KEY}"
EOF

export OSYS=${OSYS:-"GNU/linux"}
if [ $OSYS == "windows" ]; then
  echo "OSYS= [${OSYS}]"
  cat ./etc.hosts.de.addon | tee -a /c/Windows/System32/drivers/etc/hosts
else
  echo "NIX system"
  cat ./etc.hosts.de.addon | sudo tee -a /etc/hosts
fi;

docker-compose -f docker-compose-infra-services.yml up --build
# docker-compose -f docker-compose-infra-services.yml up --force-recreate

