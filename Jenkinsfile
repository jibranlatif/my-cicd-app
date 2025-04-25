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
                // Remove duplicate checkout - keep only this one
                checkout scm
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
                    // Remove duplicate -d flag and add proper Flask environment variables
                    docker.image("${DOCKER_IMAGE}:${DOCKER_TAG}").run(
                        "--name ${CONTAINER_NAME} -p 5000:5000 -e FLASK_APP=app.py -e FLASK_ENV=development"
                    )
                    
                    // Verify container started
                    sh "docker ps -f name=${CONTAINER_NAME}"
                    sh "docker logs ${CONTAINER_NAME}"
                }
            }
        }

        stage('Test Application') {
            steps {
                script {
                    // Wait longer and add retries
                    retry(3) {
                        sleep(time: 5, unit: 'SECONDS')
                        sh """
                            curl -sSf http://localhost:5000 || \
                            { echo 'Application not responding'; docker logs ${CONTAINER_NAME}; exit 1; }
                        """
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
