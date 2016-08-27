json.extract! agent, :id, :name, :aws_region, :aws_access_key, :aws_secret, :server_access_token, :created_at, :updated_at
json.url agent_url(agent, format: :json)