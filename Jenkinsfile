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
        stage("Deploy to EKS") {
            environment { // import Jenkin global variables 
                AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
                AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
                AWSREGION = "eu-west-3"
                EKSCLUSTERNAME = credentials('EKS_CLUSTER')
                NAMESPACE = "sockshop"
            }
            steps {
                // Create an Approval Button with a timeout of 15minutes.
                // this require a manuel validation in order to deploy on production environment.
                timeout(time: 15, unit: "MINUTES") {
                            input message: 'Do you want to provision in AWS ?', ok: 'Yes'
                        }
                script {
                    dir('microservice') {
                        sh 'aws eks update-kubeconfig --name sockshop-eks --region eu-west-3 --kubeconfig .kube/config'
                        //sh 'aws eks update-kubeconfig --name $EKSCLUSTERNAME --region $AWSREGION --kubeconfig .kube/config'
                        //sh 'aws eks update-kubeconfig --name sockshop-eks --region eu-west-3 --kubeconfig .kube/config'
                        sh 'rm -Rf .kube'
                        sh 'mkdir .kube'
                        sh 'touch .kube/config'
                        sh 'chmod 777 .kube/config'
                        sh 'rm -Rf .aws'
                        sh 'mkdir .aws'
                        sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
                        sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
                        sh 'aws configure set region $AWSREGION'
                        sh 'aws eks update-kubeconfig --name sockshop-eks --region eu-west-3 --kubeconfig .kube/config'
                        sh 'aws eks update-kubeconfig --name $EKSCLUSTERNAME --region $AWSREGION --kubeconfig .kube/config'
                            // Check if the namespace exists
                            def namespaceExists = sh(script: "kubectl get namespace \$NAMESPACE", returnStatus: true)
                            if (namespaceExists == 0) {
                                echo "Namespace \$NAMESPACE already exists."
                            } else {
                                // Create the namespace
                                sh 'kubectl create namespace \$NAMESPACE'
                                echo "Namespace \$NAMESPACE created."
                            }
                        sh 'kubectl apply -f ./frontend-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./catalogue-db/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./catalogue-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./carts-db/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./carts-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./queue-master-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./rabbitmq/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./user-db/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./user-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./order-db/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./orders-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./payment-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ./shipping-service/manifests -n $NAMESPACE --kubeconfig .kube/config'
                        sh 'kubectl apply -f ../ingress/manifests -n $NAMESPACE --kubeconfig .kube/config'
                    }
                }
            }
        }
    }
}
