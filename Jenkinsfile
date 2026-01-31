pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'your-docker-registry'
        DOCKER_CREDENTIALS_ID = 'your-docker-credentials'
        KUBECONFIG_CREDENTIALS_ID = 'your-kubeconfig-credentials'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your Git repository
                git 'https://github.com/your-username/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = "${env.DOCKER_REGISTRY}/devops-project:${env.BUILD_NUMBER}"
                    docker.build(imageName, '.')
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = "${env.DOCKER_REGISTRY}/devops-project:${env.BUILD_NUMBER}"
                    docker.withRegistry("https://${env.DOCKER_REGISTRY}", env.DOCKER_CREDENTIALS_ID) {
                        docker.image(imageName).push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withKubeConfig([credentialsId: env.KUBECONFIG_CREDENTIALS_ID]) {
                    sh 'kubectl apply -f deployment.yaml'
                    sh 'kubectl apply -f service.yaml'
                    // Update the deployment image with the new version
                    sh "kubectl set image deployment/devops-project-deployment devops-project=${env.DOCKER_REGISTRY}/devops-project:${env.BUILD_NUMBER}"
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
