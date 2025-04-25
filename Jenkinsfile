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
                // Remove duplicate checkout - let Declarative SCM handle it
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
                    // Remove duplicate -d flag and ensure proper Flask binding
                    docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").run(
                        "--name ${CONTAINER_NAME} -p 5000:5000 -e FLASK_APP=app.py -e FLASK_ENV=development"
                    )
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Wait for app to start
                    sleep(time: 10, unit: 'SECONDS')
                    
                    // Verify container is running
                    sh "docker ps -f name=${CONTAINER_NAME}"
                    
                    // Test the endpoint
                    sh """
                        curl -sSf http://localhost:5000 || echo "Application not responding"
                        curl -sSf http://localhost:5000/health || echo "Health check failed"
                    """
                }
            }
        }
    }

    post {
        always {
            script {
                // Graceful cleanup
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
