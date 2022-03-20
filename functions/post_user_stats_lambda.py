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
      
  body = json.dumps(event, indent=1)
  data = body["payload"]
  # Run with txt
  response = {}
  dynamodb_payload = {}
  # payload = event
  # data = payload.get("payload")

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
          ReturnValues = 'UPDATED_NEW',
          UpdateExpression = f'SET payload = :val',
          ExpressionAttributeValues = {
              ':val': {
                  'S': json.dumps(data)
              }
          }
      )
      logger.debug("Updated user_id data: ")
    else:
      logger.debug("Insert new user_id")
      dynamodb_payload={
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
          "body": "Processed data into Dynamodb "+json.dumps(body),
          'headers': {'Content-Type': 'application/json'}
      }


# lambda_handler({
#     "operation": "echo",
#     "payload": {
#         "user_id": 3,
#         "account_id": 1991,
#         "Workload": "PUT RECORD TEST",
#         "Description": "Demo API GW for integrate with Lambda Function"
#     }
# }, {})
# {\n    \"operation\": \"echo\",\n    \"payload\": {\n        \"user_id\" : 1,\n        \"account_id\": 1995,\n        \"Workload\": \"API GATEWAY TEST\",\n        \"Description\": \"Demo API GW for integrate with Lambda Function\"\n    }\n}"