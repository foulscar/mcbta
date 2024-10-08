import os
import json
import boto3

ec2Client = boto3.client("ec2")
instanceID = os.getenv("INSTANCE_ID")

def lambda_handler(event, context):
    statusCode = 0
    responseMessage = ""

    requestBodyRaw = event.get("body")
    if requestBodyRaw is None:
        return generateResponse(400, "No body found in request")

    try:
        requestBody = json.loads(requestBodyRaw)
    except json.JSONDecodeError as e:
        return generateResponse(400, "Body JSON is invalid")

    shouldStart = requestBody.get("shouldStart")
    if instanceID is None:
        statusCode = 501
        responseMessage = "INSTANCE_ID environment variable was not set"
    elif shouldStart is None:
        statusCode = 400
        responseMessage = "shouldStart was not defined"
    else:
        statusCode, responseMessage = operateBTAInstance(shouldStart)

    return generateResponse(statusCode, responseMessage)

def operateBTAInstance(shouldStart):
    responseMessage = ""
    if shouldStart:
        ec2Client.start_instances(InstanceIds=[instanceID])
        responseMessage = "Starting BTA Server..."
    else:
        ec2Client.stop_instances(InstanceIds=[instanceID])
        responseMessage = "Stopping BTA Server..."
    return 200, responseMessage

def generateResponse(statusCode, responseMessage):
    return {
        "statusCode": statusCode,
        "body": json.dumps({"message": responseMessage})
    }
