class AwsHelper::EC2 < AwsHelper::Base
	
	def initialize(server_access_token)
		super(server_access_token)
		@ec2_client = Aws::EC2::Client.new(region: aws_region, credentials: aws_credentials)
		@ec2_resource = Aws::EC2::Resource.new(client: @ec2_client)
	end

	def instances(params)
		begin 
			params.merge!(dry_run: false) if params[:dry_run].blank?
			# Fetch all instance available in region
			result = @ec2_resource.instances(params)
			return {error: {}, result: result}
		rescue Exception => e
			return {error: {code: I18n.t("aws.common.codes.custom_exception"), message: e.message}, result: []}
		end	
	end

	# def other_Aws::EC2::Resource_method
	# -- something
	# end

end