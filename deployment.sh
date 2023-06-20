#!/bin/sh

# declarations
# docker image name
DOCKER_IMAGE_NAME="bulletinboard-ads-i562327"
# docker image tag
# DOCKER_IMAGE_TAG="v4"
DOCKER_IMAGE_TAG="$1"
# registry url
REGISTRY_URL="cc-ms-k8s-training.common.repositories.cloud.sap"

# docker build
docker build --platform linux/amd64 -t  "$REGISTRY_URL/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" .
# registry login
docker login -u "claude" -p "9qR5hbhm7Dzw6BNZcRFv" "$REGISTRY_URL"
# docker push
docker push "$REGISTRY_URL/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"

# create a new k8 deployment manifest for bulletinboard-ads using the template file, with the new docker image tag
cd .k8s
rm "temp_bulletinboard-ads.yml"
sed "s/{parameterized-docker-image-tag}/$DOCKER_IMAGE_TAG/g" "3_bulletinboard-ads-template.yml" | tee "temp_bulletinboard-ads.yml"

# apply d r secret
kubectl apply -f "1_docker-registry.yml"
# apply db yaml
kubectl apply -f "2_bulletinboard-ads-db.yml"
# apply app yaml
kubectl apply -f "temp_bulletinboard-ads.yml"

cd ..
echo "Deployment completed!"
