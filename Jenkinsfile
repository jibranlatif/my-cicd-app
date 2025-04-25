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
                    sh "docker build --no-cache -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Run and Verify Container') {
            steps {
                script {
                    // Run container with health check
                    sh """
                        docker run -d \
                          --name ${CONTAINER_NAME} \
                          -p 5000:5000 \
                          -e FLASK_APP=app.py \
                          -e FLASK_ENV=development \
                          ${DOCKER_IMAGE}:${DOCKER_TAG}
                    """
                    
                    // Verify container started properly
                    def healthy = false
                    timeout(time: 1, unit: 'MINUTES') {
                        waitUntil {
                            try {
                                def status = sh(
                                    script: "docker inspect --format='{{.State.Health.Status}}' ${CONTAINER_NAME}",
                                    returnStdout: true
                                ).trim()
                                
                                if (status == 'healthy') {
                                    healthy = true
                                    return true
                                }
                                
                                // If no health check, verify logs
                                def logs = sh(
                                    script: "docker logs ${CONTAINER_NAME} 2>&1 | tail -20",
                                    returnStdout: true
                                )
                                
                                if (logs.contains('Running on http://0.0.0.0:5000')) {
                                    healthy = true
                                    return true
                                }
                                
                                sleep(5)
                                return false
                            } catch (Exception e) {
                                sleep(5)
                                return false
                            }
                        }
                    }
                    
                    if (!healthy) {
                        error("Container failed to start properly")
                    }
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    retry(3) {
                        sh """
                            curl -sSf http://localhost:5000 || \
                            { docker logs ${CONTAINER_NAME}; exit 1; }
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            script {
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
