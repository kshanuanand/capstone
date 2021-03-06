#!/usr/bin/bash -x
set -e

if [ $# -ne 1 ]
then
    exit 10
fi

stack_name=${1}

python3 -m venv .devops
. ./.devops/bin/activate
pip install boto boto3

python script/getK8sIP.py "${stack_name}"
k8shost=$(python script/getK8sIP.py "${stack_name}")
echo "k8shost: |${k8shost}|"

#aws cloudformation describe-stacks --stack-name ${stack_name} | jq
cat > infrastructure/group_vars/all/k8shosts.ini <<EOF
[k8shost]
${k8shost} ansible_user=ubuntu ansible_connection=ssh

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_ssh_private_key_file=/var/lib/jenkins/.secrets/aws-cli-test.pem
EOF

cat > infrastructure/group_vars/all/main <<EOF
image_tag: ${BUILD_ID}
registry_username: ${DOCKER_HUB_CREDS_USR}
registry_password: ${DOCKER_HUB_CREDS_PSW}
EOF
N_JOB_NAME=$(echo ${JOB_NAME} | tr '/' '_' )
echo "N_JOB_NAME: ${N_JOB_NAME}"
cd infrastructure
ansible-playbook deploy_app.yaml -i group_vars/all/k8shosts.ini
if [ $? -eq 0 ]
then
    echo "DEPLOY_STATUS:SUCCESS" > /tmp/${N_JOB_NAME}_${BUILD_NUMBER}
else
    echo "DEPLOY_STATUS:FAILURE" > /tmp/${N_JOB_NAME}_${BUILD_NUMBER}
fi
cd -