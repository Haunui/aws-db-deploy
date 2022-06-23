def exists

pipeline {
    agent any

    environment {
	AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
	AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        AWS_REGION = 'eu-west-3'
    }

    stages {
	stage('Cleanup') {
	    steps {
		script {
	            sh "bash cleanup.sh ${exists}"
		}
	    }
	}
        stage('Deploy') {
            steps {
		script {
	            sh "bash deploy.sh"
		}
            }
        }
    }
}
