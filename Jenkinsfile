pipeline {
    agent any

    environment {
        AWS_REGION = 'eu-west-3'
    }

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
