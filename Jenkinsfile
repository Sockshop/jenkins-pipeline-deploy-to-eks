pipeline {                                                                                                                                                                                                                                                                                                                                                         
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        //AWSREGION = "eu-west-3"
        AWSREGION = credentials("AWSREGION")
        EKSCLUSTERNAME = credentials("EKS_CLUSTER")
        DOCKER_ID = credentials('DOCKER_ID')
        NAMESPACE = credentials('NAMESPACE')
    }
agent any
    stages {
        stage("Create an EKS Cluster") {
            steps {
                script {
                    dir('EKS') {
                        //sh "terraform init -reconfigure"
                        sh "terraform init" 
                        sh "terraform plan"
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }
    }
}
