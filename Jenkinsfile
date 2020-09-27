pipeline{
  agent any
  stages{
    stage('Setup Workspace'){
      steps{
        sh "make setup"
        sh '''
        . .devops/bin/activate
        make install
        '''
      }
    }
    stage('Linting'){
      steps{
        sh '''
        . .devops/bin/activate
        make lint
        '''
      }
    }
    stage('Build and deploy Image'){
      steps{
        sh "docker build -t \"kshanuanand/capstone:${BUILD_NUMBER}\" ."
        sh "docker push \"kshanuanand/capstone:${BUILD_NUMBER}\""
      }
    }
    stage('Create Infrastructure'){
      parallel{
        stage('Create Green Environment'){
          steps{
            script{
              build(
                job: 'CreateDeploymentEnv',
                parameters: [
                  string(name:'EnvType',value:'green'),
                  string(name:'state',value:'present'),
                  string(name:'aws_region',value:'us-west-2'),
                  string(name:'EnvName',value:'capstone'),
                  string(name:'vpc_EnvName',value:'capstone'),
                  string(name:"EC2AmiId",value:"ami-0a634ae95e11c6f91"),
                  string(name:"EC2Key",value:"aws-cli-test"),
                  string(name:"EC2Instance",value:"t2.large")
                ]
              )
            }
          }
        }
        stage('Create Blue Environment'){
          steps{
            script{
              build(
                job: 'CreateDeploymentEnv',
                parameters: [
                  string(name:'EnvType',value:'blue'),
                  string(name:'state',value:'present'),
                  string(name:'aws_region',value:'us-west-2'),
                  string(name:'EnvName',value:'capstone'),
                  string(name:'vpc_EnvName',value:'capstone'),
                  string(name:"EC2AmiId",value:"ami-0a634ae95e11c6f91"),
                  string(name:"EC2Key",value:"aws-cli-test"),
                  string(name:"EC2Instance",value:"t2.large")

                ]
              )
            }
          }
        }
      }
    }
    stage('Deploy on Green Environment'){
      steps{
        sh "echo 'Deploy application'"

      }
      
    }
    stage('Test Application on Green Environment'){
      steps{
        sh "echo 'Test Application'"
      }
    }
    stage('Update on Blue Environment'){
      steps{
        sh "echo 'Rolling'"
      }
    }
  }
}
