#!/usr/bin/env groovy
pipeline {                                                                                                                                                                                                                                                                                                                                                         
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWSREGION = "eu-west-3"
        DB_USERNAME =   credentials('DB_USERNAME')
        DB_PASSWORD = credentials('DB_PASSWORD')
        GRAFANA_PASSWORD = credentials('GRAFANA_PASSWORD')
        EKSCLUSTERNAME = credentials('EKS_CLUSTER')
        NAMESPACE = credentials('NAMESPACE')
        //NAMESPACE = "sockshop"
    }
agent any
    stages {
        stage("Create an EKS Cluster") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                AWSREGION = "eu-west-3"
                DB_USERNAME =   credentials('DB_USERNAME')
                DB_PASSWORD = credentials('DB_PASSWORD')
                GRAFANA_PASSWORD = credentials('GRAFANA_PASSWORD')
                EKSCLUSTERNAME = credentials('EKS_CLUSTER')
                NAMESPACE = credentials('NAMESPACE')
                //NAMESPACE = "sockshop"
            }
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