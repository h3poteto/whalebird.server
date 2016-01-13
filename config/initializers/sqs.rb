sqs_client = Aws::SQS::Client.new(
  endpoint: ENV["AWS_SQS_ENDPOINT"],
  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
  region: ENV["AWS_REGION"]
)
sqs_client.create_queue(queue_name: 'loop')
sqs_client.create_queue(queue_name: 'default')
