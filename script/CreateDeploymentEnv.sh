#!/usr/bin/bash

python3 -m venv .devops
. ./.devops/bin/activate
pip install boto boto3

cat > infrastructure/group_vars/all/main <<EOF
aws_region: "${aws_region}"
EnvName: "${EnvName}"
stack_name: "${EnvName}-${EnvType}-K8s-stack"
vpc_EnvName: "${vpc_EnvName}"
state: "${state}"
EC2AmiId: "{{ EC2AmiId }}"
EC2Key: "{{ EC2Key }}"
EC2Instance: "{{ EC2Instance }}"
EOF

echo "Printing group_vars"
cat infrastructure/group_vars/all/main

cd infrastructure/
ansible-playbook createEc2.yaml -i localhost, --connection=local
cd -