pipeline {                                                                                                                                                                                                                                                                                                                                                         
    environment {
        //AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        //AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        //AWS_DEFAULT_REGION = "us-east-1"
        //AWSSECRETKEY = credentials("AWS_SECRET_KEY")
        //AWSREGION = credentials("AWS_REGION")
        //EKSCLUSTERNAME = credentials("EKS_CLUSTER")
        DOCKER_ID = credentials('DOCKER_ID')
        NAMESPACE = credentials("NAMESPACE")
    }
agent any
    stages {
        /*stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        //sh "terraform init -reconfigure"
                        //sh "terraform init"
                        sh "terraform init" 
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }*/
        stage('Build') {
            // use sequentiel build steps
            steps {
                build job: "frontend-service", wait: true

                // dbs
                build job: "catalogue-db", wait: true
                build job: "user-db", wait: true
                build job: "carts-db", wait: true
                build job: "order-db", wait: true

                // micro services
                build job: "catalogue-service", wait: true
                build job: "user-service", wait: true
                build job: "carts-service", wait: true
                build job: "orders-service", wait: true
                build job: "payment-service", wait: true
                build job: "queue-master-service", wait: true
                build job: "rabbitmq", wait: true
                build job: "shipping-service", wait: true
            }
        }
        
        /*stage("Deploy to EKS") {
            steps {
                script {
                    dir('kubernetes') {
                        sh "aws eks update-kubeconfig --name myapp-eks-cluster"
                        //sh "kubectl apply -f nginx-deployment.yaml"
                        //sh "kubectl apply -f nginx-service.yaml"
                        //sh 'kubectl get namespace'
                        sh 'kubectl create namespace $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/front-end/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/ingress -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/catalogue-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/catalogue/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/carts-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/carts/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/queue-master/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/rabbitmq/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/user-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/user/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/orders-db/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/orders/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/payment/manifests -n $NAMESPACE'
                        sh 'kubectl apply -f ../microservices/shipping/manifests -n $NAMESPACE'
                        sh 'sleep 30'
                        sh 'kubectl get ingress -n $NAMESPACE'
                        sh 'kubectl get pods -n $NAMESPACE'
                        sh 'kubectl get svc -n $NAMESPACE'
                    }
                }
            }
        }*/
    }
}
