resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "user-stats-data"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "user_id"
  range_key      = "account_id"

  attribute {
    name = "user_id"
    type = "N"
  }

  attribute {
    name = "account_id"
    type = "N"
  }
}
