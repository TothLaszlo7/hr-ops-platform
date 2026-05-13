pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins
  containers:
    - name: tools
      image: 554422868760.dkr.ecr.eu-west-1.amazonaws.com/hr-ops-jenkins-agent:latest
      command:
        - sleep
      args:
        - infinity
    - name: kaniko
      image: gcr.io/kaniko-project/executor:latest
      command:
        - /busybox/cat
      tty: true
"""
        }
    }

    environment {
        AWS_REGION = "eu-west-1"
        CLUSTER_NAME = "hr-ops-cluster"
        AWS_ACCOUNT_ID = "554422868760"
        ECR_REPOSITORY = "554422868760.dkr.ecr.eu-west-1.amazonaws.com/hr-ops-backend"
        RDS_IDENTIFIER = "hr-ops-postgres"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage("Verify AWS identity") {
            steps {
                container("tools") {
                    sh "aws sts get-caller-identity"
                }
            }
        }

        stage("Fetch deployment values") {
            steps {
                container("tools") {
                    script {
                        env.DB_HOST = sh(
                            script: "aws rds describe-db-instances --region $AWS_REGION --db-instance-identifier $RDS_IDENTIFIER --query 'DBInstances[0].Endpoint.Address' --output text",
                            returnStdout: true
                        ).trim()

                        env.DB_PORT = sh(
                            script: "aws rds describe-db-instances --region $AWS_REGION --db-instance-identifier $RDS_IDENTIFIER --query 'DBInstances[0].Endpoint.Port' --output text",
                            returnStdout: true
                        ).trim()

                        env.DB_NAME = sh(
                            script: "aws rds describe-db-instances --region $AWS_REGION --db-instance-identifier $RDS_IDENTIFIER --query 'DBInstances[0].DBName' --output text",
                            returnStdout: true
                        ).trim()

                        env.DB_SECRET_ARN = sh(
                            script: "aws rds describe-db-instances --region $AWS_REGION --db-instance-identifier $RDS_IDENTIFIER --query 'DBInstances[0].MasterUserSecret.SecretArn' --output text",
                            returnStdout: true
                        ).trim()
                    }

                    sh '''
                      echo "DB_HOST=$DB_HOST"
                      echo "DB_PORT=$DB_PORT"
                      echo "DB_NAME=$DB_NAME"
                      echo "DB_SECRET_ARN loaded"
                    '''
                }
            }
        }

        stage("Build and push backend image") {
            steps {
                container("kaniko") {
                    sh '''
                      /kaniko/executor \
                        --context "${WORKSPACE}/backend" \
                        --dockerfile "${WORKSPACE}/backend/Dockerfile" \
                        --destination "${ECR_REPOSITORY}:${IMAGE_TAG}" \
                        --destination "${ECR_REPOSITORY}:latest"
                    '''
                }
            }
        }

        stage("Deploy with Helm") {
            steps {
                container("tools") {
                    sh '''
                      aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                      helm upgrade --install hr-ops ./helm/hr-ops \
                        --set backend.image.repository=$ECR_REPOSITORY \
                        --set backend.image.tag=$IMAGE_TAG \
                        --set backend.dbSecretArn=$DB_SECRET_ARN \
                        --set backend.database.host=$DB_HOST \
                        --set backend.database.port=$DB_PORT \
                        --set backend.database.name=$DB_NAME
                    '''
                }
            }
        }

        stage("Verify rollout") {
            steps {
                container("tools") {
                    sh '''
                      kubectl rollout status deployment/backend -n hr-ops
                      kubectl get pods -n hr-ops
                    '''
                }
            }
        }
    }
}