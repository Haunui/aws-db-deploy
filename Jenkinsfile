pipeline {
    agent any

    stages {
        stage('Check if exists') {
            steps {
                echo 'Building..'
            }
        }
        stage('Deploy') {
            steps {
                bash deploy.sh
            }
        }
    }
}
