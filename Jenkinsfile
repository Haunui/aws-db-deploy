def exists

pipeline {
    agent any

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
	            bash cleanup.sh "${exists}"
		}
	    }
	}
        stage('Deploy') {
            steps {
                bash deploy.sh
            }
        }
    }
}
