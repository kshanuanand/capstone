pipeline{
  agent any
  environment{
    DOCKER_HUB_CREDS = credentials('docker_hub_login')
  }
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
    stage('Create Infrastructure Green'){
      stages{
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
        stage('Deploy on Green Environment'){
          steps{
              withAWS(region:'us-west-2',credentials:'udacity-aws-cli-user') {
                sh "echo 'Deploy application'"
                sh '''
                  bash ./script/DeployAndTest.sh "capstone-green-K8s-stack"
                '''
              }
            
          }
        }
      }
    }
    stage('Create Infrastructure Blue'){
      stages{
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
        stage('Update on Blue Environment'){
          steps{
            withAWS(region:'us-west-2',credentials:'udacity-aws-cli-user') {
              sh '''
                N_JOB_NAME=$(echo ${JOB_NAME} | tr '/' '_' )
                GREEN_STATUS=$(cat /tmp/${N_JOB_NAME}_${BUILD_NUMBER} | cut -d ':' -f2)
                if [ "${GREEN_STATUS}" = 'SUCCESS' ]
                then
                  echo "Green Deployment was success. Deploy on Blue Environment"
                  bash ./script/DeployAndTest.sh "capstone-blue-K8s-stack"
                else
                  echo "Green Deployment was failure. Skipping Blue Environment Deployment"
                fi
              '''
            }
          }
        }
      }
    }
  }
  post{
    always{
      echo "Cleaning up docker images"
      sh '''
        container_list=$(docker ps -a| grep Exited| awk '{print \$1}'| tr '\n' ' ')
        if [ "X${container_list}" != "X" ]
        then
          docker rm $container_list
        fi
      '''
      sh '''
        image_list=$(docker image ls| awk '{print \$3}'|grep -v IMAGE | tr '\n' ' ')
        if [ "X${image_list}" != "X" ]
        then
          docker rmi $image_list
        fi
      '''
    }
  }
}
