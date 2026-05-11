#!/bin/bash

set -e

NAMESPACE="hr-ops"
SECRET_NAME="backend-secret"
REGION="eu-west-1"
TERRAFORM_DIR="infrastructure/terraform/environments/dev"

cd "$TERRAFORM_DIR"

DB_ENDPOINT=$(terraform output -raw db_endpoint)
DB_HOST=$(echo "$DB_ENDPOINT" | cut -d ':' -f 1)
DB_PORT=$(terraform output -raw db_port)
DB_NAME=$(terraform output -raw db_name)
SECRET_ARN=$(terraform output -raw master_user_secret_arn)

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --region "$REGION" \
  --secret-id "$SECRET_ARN" \
  --query SecretString \
  --output text)

DB_USER=$(echo "$SECRET_JSON" | jq -r '.username')
DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r '.password')

cd ../../../..

kubectl create secret generic "$SECRET_NAME" \
  -n "$NAMESPACE" \
  --from-literal=DB_HOST="$DB_HOST" \
  --from-literal=DB_PORT="$DB_PORT" \
  --from-literal=DB_NAME="$DB_NAME" \
  --from-literal=DB_USER="$DB_USER" \
  --from-literal=DB_PASSWORD="$DB_PASSWORD" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Kubernetes secret '$SECRET_NAME' created/updated in namespace '$NAMESPACE'."