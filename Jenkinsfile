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
            
            // Verify container started properly by checking logs
            def started = false
            timeout(time: 1, unit: 'MINUTES') {
                waitUntil {
                    try {
                        def logs = sh(
                            script: "docker logs ${CONTAINER_NAME} 2>&1 | tail -20",
                            returnStdout: true
                        ).trim()
                        
                        if (logs.contains('Running on http://0.0.0.0:5000')) {
                            started = true
                            return true
                        }
                        
                        if (logs.contains('Traceback') || logs.contains('Error')) {
                            error("Container failed to start:\n${logs}")
                        }
                        
                        sleep(5)
                        return false
                    } catch (Exception e) {
                        sleep(5)
                        return false
                    }
                }
            }
            
            if (!started) {
                error("Container failed to start within timeout period")
            }
        }
    }
}
