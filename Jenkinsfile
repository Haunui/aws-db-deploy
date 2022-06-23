def exists

pipeline {
    agent any

    stages {
        stage('Check if exists') {
	    steps {
	        script {
		    exists = $(bash check_if_exists.sh)
                }
            }
        }
	stage('Cleanup') {
	    when {
		expression { exists != null }
	    }
	    steps {
	        bash cleanup.sh "${exists}"
	    }
	}
        stage('Deploy') {
            steps {
                bash deploy.sh
            }
        }
    }
}
