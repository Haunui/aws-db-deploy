pipeline {
  agent any
  stages {
    stage('Cleanup') {
      steps {
        script {
          sh "bash cleanup.sh"
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

    stage('Test') {
      parallel {
        stage('Test') {
          steps {
            script {
              sh "bash test.sh"
            }

            sh 'echo "hello world"'
          }
        }

        stage('TEST2') {
          steps {
            sh 'echo hello'
          }
        }

      }
    }

  }
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    AWS_REGION = 'eu-west-3'
  }
}