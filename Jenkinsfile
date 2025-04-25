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
                // Either use the declarative SCM checkout (recommended)
                checkout scm
                
                // OR explicitly specify git checkout
                // git branch: 'main', url: 'https://github.com/jibranlatif/my-cicd-app.git'
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
                        "--name ${CONTAINER_NAME} -p 5000:5000 -d"
                    )
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    sleep(time: 10, unit: 'SECONDS') // Wait for app to start
                    
                    // Verify container is running
                    sh "docker ps -f name=${CONTAINER_NAME}"
                    
                    // Test the endpoint
                    sh "curl -sSf http://localhost:5000 || echo 'Application not responding'"
                }
            }
        }
    }

    post {
        always {
            script {
                // Cleanup containers and images
                sh """
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true
                """
                cleanWs()
            }
        }
    }
}
