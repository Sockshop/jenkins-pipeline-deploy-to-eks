#!/usr/bin/env groovy
pipeline {
    agent any
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
    parameters {
        choice(
            name: 'ACTION',
            choices: ['Create', 'Destroy'],
            description: 'Choose whether to create or destroy the EKS cluster.'
        )
    }
    stages {
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('iaac'){
                         sh 'terraform init'
                         //sh 'terraform init -reconfigure'
                         //sh 'terraform plan'
                    }
                }
            }
        }
        stage('Creating/Destroying an EKS cluster/monitoring/rds'){
            steps{
                script {
                    def terraformAction = params.ACTION.toLowerCase()
                    dir('iaac') {
                        if (terraformAction == 'create') {
                            sh """
                    terraform apply -auto-approve \
                        -var "DB_USERNAME=\${DB_USERNAME}" \
                        -var "DB_PASSWORD=\${DB_PASSWORD}" \
                        -var "GRAFANA_PASSWORD=\${GRAFANA_PASSWORD}"
                    """
                        } else if (terraformAction == 'destroy') {
                            sh """
                    terraform destroy -auto-approve \
                        -var "DB_USERNAME=\${DB_USERNAME}" \
                        -var "DB_PASSWORD=\${DB_PASSWORD}" \
                        -var "GRAFANA_PASSWORD=\${GRAFANA_PASSWORD}"
                    """
                        } else {
                            error "Invalid action provided. Please choose either 'Create' or 'Destroy'."
                        }
                    }
                }
            }
        }
    }
}
