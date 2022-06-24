pipeline {
  agent any
  stages {
    stage('Environment Cleanup') {
      steps {
        script {
          sh "bash cleanup.sh"
        }

      }
    }

    stage('Instance Deploy.') {
      steps {
        script {
          sh "bash deploy_instance.sh"
        }
      }
    }

    stage('Instance Tests') {
      parallel {
        stage('Apache2') {
          steps {
            script {
	      sshagent (credentials: ['ssh_credentials']) {
                sh "bash test_instance_apache2.sh"
	      }
            }
          }
        }

        stage('MariaDB') {
          steps {
            script {
	      sshagent (credentials: ['ssh_credentials']) {
                sh "bash test_instance_mariadb.sh"
	      }
            }
          }
        }

      }
    }

    stage('App Deploy.') {
      steps {
        script {
	  sshagent (credentials: ['ssh_credentials']) {
	    sh "bash deploy_app.sh"
	  }
        }
      }
    }

    stage('App Tests') {
      parallel {
        stage('HTTP INDEX') {
          steps {
            script {
              sh "bash test_app_index.sh"
            }
          }
        }

        stage('HTTP DB STATUS') {
          steps {
            sh 'bash test_app_db.sh'
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
