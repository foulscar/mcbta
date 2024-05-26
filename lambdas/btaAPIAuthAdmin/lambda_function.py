import json
import os
import boto3
import pyotp

def lambda_handler(event, context):
    secretID = os.getenv("SECRET_ID")
    if secretID is None:
        print("Failed to get SECRET_ID")
        return generateResponse(False)

    client = boto3.client("secretsmanager")
    totpSecretKey = client.get_secret_value(SecretId=secretID)["SecretString"]
    if totpSecretKey is None:
        print("Failed to get totpSecretKey")
        return generateResponse(False)

    totp = pyotp.TOTP(totpSecretKey)

    totpClientToken = event.get("authorizationToken")
    if totpClientToken is None:
        print("Failed to get totpClientToken")
        return generateResponse(False)

    try:
        if totp.verify(totpClientToken):
            return generateResponse(True)
        else:
            return generateResponse(False)
    except Exception as e:
        print("Error verifying OTP token:", e)
        return generateResponse(False)

def generateResponse(isAuthorized):
    response = {
        "isAuthorized": isAuthorized
    }
    return response
