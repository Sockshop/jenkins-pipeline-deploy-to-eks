#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWSREGION = "eu-west-3"
        EKSCLUSTERNAME = credentials('EKS_CLUSTER')
    }
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('EKS-Cluster') {
                        //sh "terraform init -reconfigure"
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
    }
}
