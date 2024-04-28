#!/usr/bin/env groovy
pipeline {                                                                                                                                                                                                                                                                                                                                                         
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWSREGION = "eu-west-3"
        EKSCLUSTERNAME = credentials('EKS_CLUSTER')
        NAMESPACE = credentials('NAMESPACE')
        //NAMESPACE = "sockshop"
    }
agent any
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('iaac') {
                        //sh "terraform init -reconfigure"
                        sh "terraform init" 
                        sh "terraform plan"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
    }
}