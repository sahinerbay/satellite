pipeline {
  agent { dockerfile true }
              
  options {
    timestamps()
  }
                
  stages {
    // stage('Install Node') {
    //   when {
    //     expression {
    //       return !"node --version"
    //     }
    //   }
    //   steps {
    //     script {
    //       sh "sudo yum install -y gcc-c++ make"
    //       sh "curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -"
    //       sh "sudo yum install -y nodejs"
    //     }
    //   }
    // }
                    
    // stage('Cloning Git') {
    //   steps {
    //     git 'https://github.com/gustavoapolinario/node-todo-frontend'
    //   }
    // }
                    
    // stage('Install dependencies') {
    //   steps {
    //     sh 'npm install'
    //   }
    // }
                 
    stage('Test') {
      steps {
        sh "npm run test"
      }
    }      
  }
}