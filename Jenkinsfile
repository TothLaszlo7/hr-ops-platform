pipeline {
    agent any

    environment {
        AWS_REGION = "eu-west-1"
        CLUSTER_NAME = "hr-ops-cluster"
    }

    stages {
        stage("Verify AWS identity") {
            steps {
                sh "aws sts get-caller-identity"
            }
        }

        stage("Verify EKS access") {
            steps {
                sh "aws eks describe-cluster --region $AWS_REGION --name $CLUSTER_NAME"
            }
        }

        stage("Verify tools") {
            steps {
                sh "aws --version"
                sh "kubectl version --client"
                sh "helm version"
                sh "docker --version"
            }
        }
    }
}