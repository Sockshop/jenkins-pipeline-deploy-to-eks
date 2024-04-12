pipeline {                                                                                                                                                                                                                                                                                                                                                         
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWSREGION = "eu-west-3"
        //AWSREGION = credentials("AWS_REGION")
        EKSCLUSTERNAME = credentials("EKS_CLUSTER")
        DOCKER_ID = credentials('DOCKER_ID')
        NAMESPACE = credentials('NAMESPACE')
    }
agent any
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('EKS-Cluster') {
                        //sh "terraform init -reconfigure"
                        //sh "terraform init"
                        sh "terraform init" 
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage ('AWS elb') {
            /*steps {
                sh 'rm -Rf .aws'
                sh 'mkdir .aws'
                sh 'aws configure set aws_access_key_id $AWSKEY'
                sh 'aws configure set aws_secret_access_key $AWSSECRETKEY'
                sh 'aws configure set region $AWSREGION'
                sh 'aws configure set output text'
                sh 'aws eks --region $AWSREGION update-kubeconfig --name $EKSCLUSTERNAME'
                sh 'kubectl apply -f alb-sa.yaml'
                sh 'helm repo add eks https://aws.github.io/eks-charts'
                sh 'helm repo update eks'
                sh 'helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=$EKSCLUSTERNAME --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller'
                sh 'sed -i "s+name:.*replace.*+name: ${NAMESPACE}+g" shop-namespace.yaml'
                sh 'kubectl apply -f shop-namespace.yaml'
                sh 'kubectl apply -f shop-ingress.yaml -n $NAMESPACE'
            }*/
        }
        stage ('setup monitoring') {
            steps {
                /*script {
                    dir('monitoring') {
                        sh 'rm -Rf .aws'
                        sh 'mkdir .aws'
                        sh 'aws configure set aws_access_key_id $AWSKEY'
                        sh 'aws configure set aws_secret_access_key $AWSSECRETKEY'
                        sh 'aws configure set region $AWSREGION'
                        sh 'aws configure set output text'
                        sh 'aws eks --region $AWSREGION update-kubeconfig --name $EKSCLUSTERNAME'
                        //sh 'helm uninstall prometheus --namespace monitoring'
                        sh 'helm repo add prometheus-community https://prometheus-community.github.io/helm-charts'
                        sh 'helm repo update'
                        sh 'kubectl apply -f monitor-namespace.yaml'
                        sh 'helm upgrade --install --timeout=15m prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --set grafana.service.type=NodePort --set promotheus.service.type=NodePort'
                        sh 'kubectl apply -f monitor-ingress.yaml'
                    }
                }*/    
            }
        }
        /*stage ('setup Velero') {
            steps {
                scripts {
                    dir('backups') {
                        sh 'rm -Rf .aws'
                        sh 'mkdir .aws'
                        sh 'aws configure set aws_access_key_id $AWSKEY'
                        sh 'aws configure set aws_secret_access_key $AWSSECRETKEY'
                        sh 'aws configure set region $AWSREGION'
                        sh 'aws configure set output text'
                        sh 'aws eks --region $AWSREGION update-kubeconfig --name $EKSCLUSTERNAME'
                        sh 'eksctl create iamserviceaccount --cluster=$EKSCLUSTERNAME --name=velero-server --namespace=velero --role-name=eks-velero-backup --role-only --attach-policy-arn=arn:aws:iam::700778905650:policy/TfEKSVeleroPolicy --approve'
                        sh 'helm repo add vmware-tanzu https://vmware-tanzu.github.io/helm-charts'
                        sh 'kubectl apply -f backup-namespace.yaml'
                        sh 'helm upgrade --install --timeout=15m velero vmware-tanzu/velero --version 5.0.2 --namespace velero -f values.yaml'
                    }
                }        
            }
        }*/
        stage('Build') {
            // use sequentiel build steps
            /*steps {
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
            }*/
        }
    }
}
