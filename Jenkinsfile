pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'my-cicd-app-image'
        DOCKER_TAG = 'latest'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/jibranlatif/my-cicd-app.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE, '.')
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).run('-d -p 5000:5000')
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    docker.image(DOCKER_IMAGE).remove()
                }
            }
        }
    }

    post {
        always {
            cleanWs()
        }
    }
}
