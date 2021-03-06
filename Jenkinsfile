pipeline {
  agent any
  stages {
    stage('Env. Cleanup') {
      steps {
        build job: 'aws-db-destroy/master', wait: true
      }
    }

    stage('Instance Deploy.') {
      steps {
        script {
          sshagent (credentials: ['bkp_ssh_credentials']) {
            sh "bash deploy_instance.sh"
          }
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

        build job: 'aws-db-restore', parameters: [string(name: 'DATABASE', value: "${env.DATABASE}"), booleanParam(name: 'NEW_ENV', value: false)], wait: true
      }
    }

    stage('App Tests') {
      parallel {
        stage('HTTP Index') {
          steps {
            script {
              sh "bash test_app_index.sh"
            }
          }
        }

        stage('HTTP DB Status') {
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
