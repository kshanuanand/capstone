#!/usr/bin/bash

cat > ../group_vars/all/main <<EOF
aws_region: "${aws_region}"
stack_name: "${EnvName}-network-stack"
EnvName: "${EnvName}"
vpcCidr: "${vpcCidr}"
pubSubnet1: "${pubSubnet1}"
pubSubnet2: "${pubSubnet2}"
privSubnet1: "${privSubnet1}"
privSubnet2: "${privSubnet2}"
EOF

cd ../infrastructure/
ansible-playbook createInfrastructure.yaml 