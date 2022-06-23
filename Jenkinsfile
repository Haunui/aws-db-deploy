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

    stage('Deploy Instance') {
      steps {
        script {
          sh "bash deploy.sh"
        }

      }
    }

    stage('Test') {
      parallel {
        stage('HTTP INDEX') {
          steps {
            script {
              sh "bash test_http_index.sh"
            }
          }
        }

        stage('HTTP DB STATUS') {
          steps {
            sh 'bash test_http_db.sh'
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
