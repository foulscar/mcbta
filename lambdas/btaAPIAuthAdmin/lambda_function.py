import json
import os
import boto3
import pyotp

def lambda_handler(event, context):
    secretID = os.getenv("SECRET_ID")
    response = None
    if secretID is None:
        print("Failed to get SECRET_ID")
        return False

    client = boto3.client("secretsmanager")
    totpSecretKey = client.get_secret_value(SecretId=secretID)["SecretString"]
    if totpSecretKey is None:
        print("Failed to get totpSecretKey")
        return False

    totp = pyotp.TOTP(totpSecretKey)

    totpClientToken = event.get("authorizationToken")
    if totpClientToken is None:
        print("Failed to get totpClientToken")
        return False

    try:
        if totp.verify(totpClientToken):
            return True
        else:
            return False
    except Exception as e:
        print("Error verifying OTP token:", e)
        return False
