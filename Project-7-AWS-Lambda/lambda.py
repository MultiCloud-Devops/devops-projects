import boto3
import urllib.request
import os

slack_webhook_url = os.environ.get("slackHookUrl")

def lambda_handler(event, context):
    try:
        print(event)

        bucket_name = event['Records'][0]['s3']['bucket']['name']
        object_key = event['Records'][0]['s3']['object']['key']

        ec2 = boto3.client('ec2')
        ssm = boto3.client('ssm')

        s3url = f"s3://{bucket_name}/{object_key}"
        print(f"S3 URL: {s3url}")

        ec2_instances = ec2.describe_instances(
            Filters=[
                {
                    'Name': 'tag:AppName',
                    'Values': ['WebServer']
                },
                {
                    'Name': 'instance-state-name',
                    'Values': ['running']
                }
            ]
        )

        instances = [
            instance['InstanceId']
            for reservation in ec2_instances['Reservations']
            for instance in reservation['Instances']
        ]

        # Safety check
        if not instances:
            print("No instances found with tag AppName=WebServer")
            return {"statusCode": 404, "body": "No instances found"}
        else:
            print(f"Target Instances: {instances}")

        # SSM command: Send S3 URL to document
        response = ssm.send_command(
            InstanceIds=instances,
            DocumentName="website-auto-deloyment",  # Correct document name
            Parameters={
                "S3Url": [s3url]   # full S3 URL passed here
            },
        )

        command_id = response["Command"]["CommandId"]
        print(f"SSM Command Response: {response}")

        return {
            "statusCode": 200,
            "body": f"SSM command sent successfully. CommandId: {command_id}"
        }

    except ssm.exceptions.InvalidInstanceId as e:
        return {
            "statusCode": 400,
            "body": f"Invalid instance ID: {str(e)}"
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error sending SSM command: {str(e)}"
        }
