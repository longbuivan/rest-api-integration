# API GATEWAY Integrated with AWS Lambda Function

## Resource

1. API GATEWAY
2. GATEWAY INTEGRATION
3. METHOD
4. LAMBDA

## Setup on Local

Use Docker to host localstack
Run command

> `docker-compose -f ./docker-compose.ymp up -d`

## Test API with cURL

- GET Method:
  > `curl -v http://localhost:4566/restapis/<restapi_id>/stage/_user_request_/api`
- POST Method:
  > `curl -v -d '{"operation":"echo","payload":"event data"}' http://localhost:4566/restapis/<restapi_id>/stage/_user_request_/api -H "Content-Type: application/json"`
  > or
  > `curl -v -d @data.json http://localhost:4566/restapis/<restapi_id>/stage/_user_request_/api -H "Content-Type: application/json"`

### **AWS CLI Local**

> awslocal dynamodb scan --table-name user-stats-data

## How to Test REST API

- GET user*stats_data: `curl -v http://localhost:4566/restapis/<restapi_id>/stage/\_user_request*/get_user_stats_data`
- POST user*stats_data: `curl -v http://localhost:4566/restapis/<restapi_id>/stage/\_user_request*/post_user_stats_data -d @/resources/data.txt`
