#!/bin/bash


mkdir -p $HOME/docker/volumes/postgres
mkdir -p $HOME/.github


# docker pull docker.redpanda.com/redpandadata/redpanda:v23.2.6
# docker pull docker.redpanda.com/redpandadata/console:v2.3.1
# docker pull docker.redpanda.com/redpandadata/redpanda:v23.2.6
# docker pull minio/minio:RELEASE.2023-08-29T23-07-35Z
# docker pull amazon/aws-cli
# docker pull mageai/mageai:latest
# docker pull jupyter/minimal-notebook:latest
# docker pull postgres:13.3
# docker pull hatmatrix/blog:base


echo "MYSQL_ROOT_PASSWORD=very_strong_password" > .secrets



# docker-compose -f docker-compose-infra-services.yml up --build
docker-compose -f docker-compose-infra-services.yml up --force-recreate

