#!/usr/bin/bash

python3 -m venv .devops
. ./.devops/bin/activate
pip install boto boto3

cat > infrastructure/group_vars/all/main <<EOF
aws_region: "${aws_region}"
stack_name: "${EnvName}-network-stack"
EnvName: "${EnvName}"
vpcCidr: "${vpcCidr}"
pubSubnet1: "${pubSubnet1}"
pubSubnet2: "${pubSubnet2}"
privSubnet1: "${privSubnet1}"
privSubnet2: "${privSubnet2}"
EOF

echo "Printing group_vars"
cat infrastructure/group_vars/all/main

cd infrastructure/
ansible-playbook createInfrastructure.yaml -i localhost, --connection=local
cd -