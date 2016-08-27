class AwsHelper::Base

	def initialize(server_access_token)
		@aws_access_details = Agent.aws_data(server_access_token)		
	end

	def aws_region
		@aws_access_details.aws_region
	end

	def aws_credentials
		Aws::Credentials.new(@aws_access_details.aws_access_key, @aws_access_details.aws_secret)
	end

end