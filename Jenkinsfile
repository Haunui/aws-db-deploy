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
          sh "bash deploy_instance.sh"
	  sh "cat instance_ip"
        }
      }
    }

    stage('Deploy App') {
      steps {
        script {
	  sshagent (credentials: ['ssh_credentials']) {
	    sh "bash deploy_app.sh"
	  }
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
  post {
    always {
      archiveArtifacts artifacts: 'mysql_root_password'
    }
  }
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    AWS_REGION = 'eu-west-3'
  }
}
