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
        }
      }
    }
    
    stage('Deploy App') {
      steps {
        script {
	  sshagent (credentials: ['1d0a0f84-dbef-4f8c-95a2-1f8cc7ae7ff4']) {
	    sh "bash deploy_app.sh"
	    exit 0
            sh "rm -rf /var/www/html/*"
	    sh "scp -r webapp/* ubuntu@$(cat instance_ip):/var/www/html/"
	    sh "mysql < /var/www/html/db.sql; rm -f /var/www/html/db.sql"
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
  environment {
    AWS_ACCESS_KEY_ID = credentials('aws_access_key_id')
    AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    AWS_REGION = 'eu-west-3'
  }
}
