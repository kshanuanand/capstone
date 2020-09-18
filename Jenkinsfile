pipeline{
  agent any
  stages{
    stage('Setup Workspace'){
      steps{
        sh "make setup"
        sh "make install"
      }
    }
    stage('Linting'){
      steps{
        sh "make lint"
      }
    }
    stage('Build and deploy Image'){
      steps{
        sh "docker build -t \"kshanuanand/capstone:${BUILD_NUMBER}\" ."
        sh "docker push"
      }
    }
    stage('Create Infrastructure'){
      steps{
        sh "echo 'Create Infrastructure'"
      }
    }
    stage('Deploy application'){
      steps{
        sh "echo 'Deploy application'"
      }
      
    }
    stage('Test Application'){
      steps{
        sh "echo 'Test Application'"
      }
    }
    stage('Rolling upgrade to Production'){
      steps{
        sh "echo 'Rolling'"
      }
    }
  }
}
