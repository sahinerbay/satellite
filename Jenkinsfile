pipeline {
  agent any

  environment {
    DOCKER_IMAGE_TAG = "my-app:build-${env.BUILD_ID}"
    WORKSPACE = "${HOME}/workspace/${JOB_NAME}"
    TERRAFORM_CMD = "docker container run --rm -v ${WORKSPACE}/tf:/home/satellite/tf --workdir /home/satellite/tf hashicorp/terraform:light"
  }
              
  options {
    timestamps()
    timeout(time: 5, unit: "MINUTES")
    buildDiscarder(logRotator(numToKeepStr: null))
  }
                
  stages {
    stage("Build") {
      steps {
        sh "docker image build --target build -t ${env.DOCKER_IMAGE_TAG} ."
      }
    }      

    stage("Test") {
      steps {
        sh "docker container run --rm ${env.DOCKER_IMAGE_TAG} npm run test"
      }
    } 

    stage("Deploy to Dev") {
      steps {
        sh """
          chmod 700 ./deploy.sh
          ./deploy.sh
        """
      } 
    }

    stage('Deploy to Prod') {
      when {
        expression {
          env.GIT_BRANCH.toString().equals('origin/development')
        }
      }

      stages {
        stage("Push the Image") {
          steps {
            sh "docker image build --target prod -t frontend:prod ."
            sh "echo push image to docker registry"
          }
        }

        stage("TF Plan") {
          steps {
            withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
              sh "${TERRAFORM_CMD} init"
              sh "${TERRAFORM_CMD} plan -out fed"
            }
          }
        }

        stage("TF Apply") {
          steps {
            withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
              sh "${TERRAFORM_CMD} -input=false myplan"
              sh "aws s3 cp personal-blog/src/_site/ s3://www.my-awesome-site.com/ --recursive"
            }
          }
          options {
            timeout(time: 8, unit: 'HOURS') 
          }
          input {
            message "Should we continue?"
          }
        }
      }
    }
  }

  triggers {
    pollSCM("H/4 * * * *") 
  }

  post {
    always {
      sh "sudo chown -Rh jenkins:jenkins /var/lib/jenkins/workspace/satellite/*"
      deleteDir() 
      sh "docker image rm -f ${env.DOCKER_IMAGE_TAG}"
    }
    failure {
      mail to: 'team@example.com',
      subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
      body: "Something is wrong with ${env.BUILD_URL}"
    }
  }
}