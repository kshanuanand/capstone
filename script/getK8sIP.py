import boto
import boto3
import sys
sName = sys.argv[1]
cfn = boto3.client('cloudformation')
responseCfn = cfn.describe_stacks(StackName=sName)

Outputs = responseCfn['Stacks'][0]['Outputs']
k8shost = ''
for output in Outputs:
    print(output)
    if output['OutputKey'] == 'Ec2IPPUB':
        k8shost = output['OutputValue']
        break;
return k8shost