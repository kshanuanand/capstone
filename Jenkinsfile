pipeline{
  agent any
  stages{
    stage('Setup Workspace'){
      make setup
      make install
    }
    stage('Linting'){
      make lint
    }
    stage('Build and deploy Image'){
      steps{
        docker build -t kshanuanand/capstone:${BUILD_NUMBER} .
        docker push
      }
    }
    stage('Create Infrastructure'){
    }
    stage('Deploy application'){
    }
    stage('Test Application'){
    }
    stage('Rolling upgrade to Production'){
    }
  }
}
