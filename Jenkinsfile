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
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Force rebuild by adding --no-cache
                    sh "docker build --no-cache -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run with proper environment variables
                    sh """
                        docker run -d \
                          --name ${CONTAINER_NAME} \
                          -p 5000:5000 \
                          -e FLASK_APP=app.py \
                          -e FLASK_ENV=development \
                          ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                    
                    // Verify container started
                    sh "docker ps -f name=${CONTAINER_NAME}"
                    sh "docker logs ${CONTAINER_NAME} --tail 20"
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    // Wait with timeout and retries
                    timeout(time: 1, unit: 'MINUTES') {
                        waitUntil {
                            try {
                                sh """
                                    curl -sSf http://localhost:5000 && \
                                    echo "Application is running" && \
                                    exit 0 || \
                                    { echo "Waiting for application to start..."; exit 1; }
                                """
                                return true
                            } catch (Exception e) {
                                sleep(5)
                                return false
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Cleanup
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
