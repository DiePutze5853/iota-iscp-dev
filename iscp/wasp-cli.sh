#!/bin/bash

serviceName="daobee_dev_wasp"
if [ -z $(docker-compose ps -q $serviceName) ] || [ -z $(docker ps -q --no-trunc | grep $(docker-compose ps -q $serviceName)) ]; then
  docker-compose up $serviceName -d
fi

toExecute="/usr/bin/wasp-cli $@ -c /etc/wasp-cli.json"
docker-compose exec $serviceName $toExecute