#!/bin/bash

set -e

REGION="eu-west-1"
ACCOUNT_ID="554422868760"
REPOSITORY_NAME="hr-ops-backend"
IMAGE_TAG="latest"

ECR_REGISTRY="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
IMAGE_URI="$ECR_REGISTRY/$REPOSITORY_NAME:$IMAGE_TAG"

echo "Logging in to ECR..."
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ECR_REGISTRY"

echo "Building backend image..."
docker build -t "$REPOSITORY_NAME" ./backend

echo "Tagging image..."
docker tag "$REPOSITORY_NAME:$IMAGE_TAG" "$IMAGE_URI"

echo "Pushing image to ECR..."
docker push "$IMAGE_URI"

echo "Image pushed successfully: $IMAGE_URI"