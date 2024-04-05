pipeline {
    agent any
    environment {
        GLOBAL_VAR = 'global_value'
    }

    stages {
        stage('Call Child Pipelines') {
            steps {
                script {
                    // Define repositories and corresponding Jenkinsfiles
                    def repos = [
                        //[url: 'https://github.com/Sockshop/shipping-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/carts-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/catalogue-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/order-db.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/orders-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/queue-master-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/user-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/user-db.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/payment-service.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/catalogue-db.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/carts-db.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/rabbitmq.git', jenkinsfile: 'Jenkinsfile'],
                        [url: 'https://github.com/Sockshop/frontend-service.git', jenkinsfile: 'Jenkinsfile']
                    ]    

                    // Loop through each repository and trigger the corresponding Jenkinsfile sequentially
                    for (int i = 0; i < repos.size(); i++) {
                        def repo = repos[i]
                        
                        // Checkout the repository
                        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: repo.url]]])

                        // Run the Jenkinsfile in the repository
                        build job: repo.jenkinsfile
                        
                        // Wait for the current repository build to finish before proceeding to the next one
                        if (i < repos.size() - 1) {
                            stage("Wait for next repo") {
                                sleep(time: 30, unit: 'SECONDS') // Adjust sleep time as needed
                            }
                        }
                    }
                }
            }
        }
    }
}
