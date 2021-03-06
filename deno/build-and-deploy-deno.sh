#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

denoarr=( $(curl -sL https://api.github.com/repos/denoland/deno/tags | jq --raw-output '.[] | .name | ltrimstr("v")' ))
dockerarr=( $(curl -sL https://registry.hub.docker.com/v1/repositories/mikolaj6r/deno/tags | jq --raw-output '.[] | .name | ltrimstr("v")' ))

for item in ${denoarr[*]}
do
   if [[ ! " ${dockerarr[@]} " =~ " ${item} " ]]; then
      docker build --build-arg DENO_VERSION=${item} . --file deno/alpine.dockerfile --tag mikolaj6r/deno:${item}
      docker push mikolaj6r/deno:${item}
   fi 
done

