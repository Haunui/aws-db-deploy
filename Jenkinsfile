def exists

pipeline {
    agent any

    environment {
	AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
	AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_REGION = 'eu-west-3'
    }

    stages {
        stage('Check if exists') {
	    steps {
	        script {
		    exists = sh(script: 'bash check_if_exists.sh', returnStdout: true)
                }
            }
        }
	stage('Cleanup') {
	    when {
		expression { exists != null }
	    }
	    steps {
		script {
	            sh(script: 'cleanup.sh ${exists}', returnStdout: false)
		}
	    }
	}
        stage('Deploy') {
            steps {
		script {
	            sh(script: 'deploy.sh', returnStdout: false)
		}
            }
        }
    }
}
