#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWSREGION = "eu-west-3"
        EKSCLUSTERNAME = "sockshop-eks-cluster"
        //NAMESPACE = credentials('NAMESPACE')
        NAMESPACE = "sockshop"
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
                    dir('EKS'){
                         sh 'terraform init -reconfigure'
                    }
                }
            }
        }
        stage('Creating/Destroying an EKS cluster'){
            steps{
                script {
                    def terraformAction = params.ACTION.toLowerCase()
                    dir('EKS') {
                        if (terraformAction == 'create') {
                            sh 'terraform apply --auto-approve'
                        } else if (terraformAction == 'destroy') {
                            sh 'terraform destroy --auto-approve'
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
                // this require a manuel validation in order to deploy on production environment
                timeout(time: 15, unit: "MINUTES") {
                            input message: 'Do you want to provision in AWS ?', ok: 'Yes'
                        }
                script {
                    dir('microservice') {
                        sh 'aws eks update-kubeconfig --name $EKSCLUSTERNAME --region $AWSREGION --kubeconfig .kube/config'
                        //sh 'aws eks update-kubeconfig --name sockshop-eks-cluster --region eu-west-3 --kubeconfig .kube/config'
                        // Check if the namespace exists
                            def namespaceExists = sh(script: "kubectl get namespace \$NAMESPACE", returnStatus: true)
                            if (namespaceExists == 0) {
                                echo "Namespace \$NAMESPACE already exists."
                            } else {
                                // Create the namespace
                                sh 'kubectl create namespace \$NAMESPACE'
                                echo "Namespace \$NAMESPACE created."
                            }
                        
                        sh 'kubectl apply -f ./front-end/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./catalogue-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./catalogue/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./carts-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./carts/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./queue-master/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./rabbitmq/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./user-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./user/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./orders-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./orders/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./payment/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ./shipping/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../ingress/manifests -n $NAMESPACE'
                        sh 'sleep 30'
                        sh 'kubectl get ingress -n $NAMESPACE'
                        sh 'kubectl get pods -n $NAMESPACE'
                        sh 'kubectl get svc -n $NAMESPACE'
                    }
                }
            }
        }
    }
}
