import boto boto3
import sys
sName = sys.argv[1]
cfn = boto3.client('cloudformation')
responseCfn = cfn.describe_stacks(StackName=sName)

Outputs = responseCfn['Stacks'][0]['Outputs']
for output in Outputs:
    print(output)