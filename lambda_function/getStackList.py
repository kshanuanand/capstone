import json
import boto3
def lambda_handler(event, context):
    # TODO implement
    if 'EnvName' in event and 'EnvType' in event:
        envName = event['EnvName']
        envType = event['EnvType']
        cfn = boto3.client('cloudformation')
        responsecfn = cfn.list_stacks(
            StackStatusFilter=[
                'CREATE_COMPLETE',
            ]
        )
        stackList = responsecfn['StackSummaries']
        stackisPresent=False
        stackNameToCheck = envName + '-' + envType + '-k8s-stack'
        print('Name to Check |{}|'.format(stackNameToCheck))
        for stack in stackList:
            stName = stack['StackName']
            print('This stack name |{}|'.format(stName))
            print(stackNameToCheck == stName)
            if stackNameToCheck == stName:
                stackisPresent=True
                break
        return {
            'statusCode': 200,
            'body': json.dumps('Hello from Lambda!'),
            'stackStatus': stackisPresent,
            'stackName':stName
        }
    else:
        return {
            'statusCode': 200,
            'body': 'You did not pass any parameters'
        }