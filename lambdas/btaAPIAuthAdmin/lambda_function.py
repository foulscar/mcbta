import json
import os
import boto3
import pyotp

def lambda_handler(event, context):
    secretID = os.getenv("SECRET_ID")
    response = None
    if secretID is None:
        print("Failed to get SECRET_ID")
        response = generatePolicy('user', 'DENY', event['methodArn'])
        return response

    client = boto3.client("secretsmanager")
    totpSecretKey = client.get_secret_value(SecretId=secretID)["SecretString"]
    if totpSecretKey is None:
        print("Failed to get totpSecretKey")
        response = generatePolicy('user', 'DENY', event['methodArn'])
        return response

    totp = pyotp.TOTP(totpSecretKey)

    totpClientToken = event.get("authorizationToken")
    if totpClientToken is None:
        print("Failed to get totpClientToken")
        response = generatePolicy('user', 'DENY', event['methodArn'])
        return response

    try:
        if totp.verify(totpClientToken):
            response = generatePolicy('user', 'Allow', event['methodArn'])
        else:
            response = generatePolicy('user', 'DENY', event['methodArn'])
    except Exception as e:
        print("Error verifying OTP token:", e)
        response = generatePolicy('user', 'DENY', event.get('methodArn', ''))

    try:
        return json.loads(response)
    except BaseException:
        print("error")
        return 'unauthorized'


def generatePolicy(principalId, effect, resource):
    authResponse = {}
    authResponse['principalId'] = principalId
    if (effect and resource):
        policyDocument = {}
        policyDocument['Version'] = '2012-10-17'
        policyDocument['Statement'] = []
        statementOne = {}
        statementOne['Action'] = 'execute-api:Invoke'
        statementOne['Effect'] = effect
        statementOne['Resource'] = resource
        policyDocument['Statement'] = [statementOne]
        authResponse['policyDocument'] = policyDocument
    authResponse_JSON = json.dumps(authResponse)
    return authResponse_JSON
