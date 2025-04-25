pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-cicd-app-image'
        DOCKER_TAG = 'latest'
        CONTAINER_NAME = 'my-cicd-app-container'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                     url: 'https://github.com/jibranlatif/my-cicd-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", '.')
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").run(
                        "--name ${CONTAINER_NAME} -d -p 5000:5000 --rm"
                    )
                }
            }
        }

        stage('Test') {
            steps {
                // Example test - replace with your actual tests
                sh 'curl -sSf http://localhost:5000 || true'
                sleep(time: 5, unit: 'SECONDS')
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Graceful cleanup commands
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    sh "docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true"
                }
            }
        }
    }

    post {
        always {
            script {
                // Final cleanup in case previous steps failed
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
                cleanWs()
            }
        }
    }
}
