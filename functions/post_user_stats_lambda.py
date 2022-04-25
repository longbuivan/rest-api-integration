import base64
from cmath import log
import json
import logging
import boto3

dynamodb_client = boto3.client(
    "dynamodb", endpoint_url="http://localhost:4566", region_name="us-east-1")

logger = logging.getLogger()
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s: %(levelname)s: %(message)s')

USER_TABLE_NAME = 'user-stats-data'


def lambda_handler(event, context):
    # return json.loads(json.dumps(event))
    # body = json.dumps(event)
    # data = event["payload"]

    # Run with txt
    response = {}
    dynamodb_payload = {}
    payload = event
    data = payload.get("body")
    # payload = json.loads(json.dumps(event))
    # data = payload['operation']
    # return data
    try:
        user_id_num = dynamodb_client.get_item(
            TableName=USER_TABLE_NAME,
          Key={
              'user_id': {'N': str(data['user_id'])},
            'account_id': {'N': str(data['account_id'])}
          }
        )
        if user_id_num:
            logger.debug("Update user_id data: ")
            dynamodb_payload = {
                'user_id': {'N': str(data['user_id'])},
                'account_id': {'N': str(data['account_id'])},
                }
            response['dynamodb'] = dynamodb_client.update_item(
                TableName=USER_TABLE_NAME,
                Key=dynamodb_payload,
                ReturnValues='UPDATED_NEW',
                UpdateExpression=f'SET payload = :val',
                ExpressionAttributeValues={
                    ':val': {
                        'S': json.dumps(data)
                    }
                }
            )
            logger.debug("Updated user_id data: ")
        else:
            logger.debug("Insert new user_id")
            dynamodb_payload = {
                'user_id': {'N': str(data['user_id'])},
                'account_id': {'N': str(data['account_id'])},
                'payload': {'S': json.dumps(data)}
                }
            response['dynamodb'] = dynamodb_client.put_item(
                TableName=USER_TABLE_NAME,
              Item=dynamodb_payload
            )
    except Exception as general_err:
        response['status'] = {
            "body": f"General Error {general_err}",
        }
    else:
        response['status'] = {
            "statusCode": 200,
            "body": "Processed data into Dynamodb "+str(dynamodb_payload),
        }
    return {
        "body": "Processed data into Dynamodb "+json.dumps(payload),
            'headers': {'Content-Type': 'application/json'}
    }
