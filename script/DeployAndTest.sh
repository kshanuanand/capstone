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

python getK8sIP.py "${stack_name}"
k8shost=''

aws cloudformation describe-stacks --stack-name ${stack_name} | jq
cat > infrastructure/group_vars/all/k8shosts.ini <<EOF
[k8shost]
"${k8shost}" ansible_user=ubuntu ansible_connection=ssh

[all:vars]
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_ssh_private_key_file=/var/lib/jenkins/.secrets/aws-cli-test.pem
ansible_python_interpreter: /usr/bin/python3
EOF

cat > infrastructure/group_vars/all/main <<EOF
image_tag: ${BUILD_ID}
EOF

cd infrastructure
ansible-playbook deploy_app.yaml -i group_vars/all/k8shosts.ini
cd -