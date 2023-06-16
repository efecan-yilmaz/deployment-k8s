#!/bin/sh

# declarations
# docker image name
DOCKER_IMAGE_NAME="bulletinboard-ads-i562327"
# docker image tag
DOCKER_IMAGE_TAG="v4"
# registry url
REGISTRY_URL="cc-ms-k8s-training.common.repositories.cloud.sap"

# docker build
docker build --platform linux/amd64 -t  "$REGISTRY_URL/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" .
# registry login
docker login -u "claude" -p "9qR5hbhm7Dzw6BNZcRFv" "$REGISTRY_URL"
# docker push
docker push "$REGISTRY_URL/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"

# k8 manifest apply (change placeholders)
# apply d r secret
kubectl apply -f ./.k8s/1_docker-registry.yml
# apply db yaml
kubectl apply -f ./.k8s/2_bulletinboard-ads-db.yml
# apply app yaml
kubectl apply -f ./.k8s/3_bulletinboard-ads.yml

#echo $(pwd)
# TODO: dynamic parameter interception
#   1 accept arguements inline for container image version
#   2 write to bulletinboards-ads.yml as a parameter
# TODO: if else check? to make it idempotent

# finish echo ?
echo "Deployment completed!"
