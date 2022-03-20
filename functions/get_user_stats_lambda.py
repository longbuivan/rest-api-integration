import logging
import boto3
from botocore.exceptions import ClientError

dynamodb_client = boto3.client(
    "dynamodb", endpoint_url="http://localhost:4566", region_name="us-east-1")

logger = logging.getLogger()
logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s: %(levelname)s: %(message)s')
USER_TABLE_NAME = 'user-stats-data'

def lambda_handler(event, context):
    response = {}
    try:
        logger.debug("Calling get_user_stats_lambda")
        data = dynamodb_client.scan(
            TableName = "user-stats-data"
        )
        # user_data = dynamodb_client.get_item(
        #     TableName='user-stats-data',
        #     Key={
        #         ''
        #     }
        # )
        response["table_data"] = data["Items"]
    except ClientError as client_err:
        response = {
            "body": f"Connection error: {client_err}"
        }
    except Exception as general_err:
        response = {
            "body": f"General error: {general_err}"
        }
    else:
        response = {
            "statusCode": 200,
            "body": "Table scan: " + str(response)
        }
    return response
