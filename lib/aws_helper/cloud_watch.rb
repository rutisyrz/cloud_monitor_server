class AwsHelper::CloudWatch < AwsHelper::Base

	def initialize(server_access_token)
		super(server_access_token)
		@cloudwatch = Aws::CloudWatch::Client.new(region: aws_region,credentials: aws_credentials)
	end

	def metrics_details(params)
		begin 			
			# Fetch all metrics
			result = @cloudwatch.list_metrics(params).metrics
			return {error: {}, result: result}
		rescue Aws::CloudWatch::Errors::InvalidParameterValue => e
			return {error: {code: e.code.to_s, message: e.message}, result: []}
		rescue ArgumentError => e
			return {error: {code: I18n.t("aws.cloud_watch.codes.invalid_argument"), message: e.message}, result: []}
		rescue Exception => e
			return {error: {code: I18n.t("aws.common.codes.custom_exception"), message: I18n.t("aws.common.errors.custom_exception")}, result: []}
		end
	end

	# Returns list of required DIMENSIONS to be passed in GET-STATISTIC api to fetch metric-statistics
	#
	## Note: 
	# Find namespace value for custom metrics in mon-put-instance-data.pl file at line: 413
	# file path - /aws-scripts-mon/mon-put-instance-data.pl:
  #  411  $params{'Input'} = {};
  #  412  my $input_ref = $params{'Input'}; 
  #  413: $input_ref->{'Namespace'} = "System/Linux";
  #	
	def metrics_config_details(namespace, metric_name=nil)
		config_details, params = {}, {}
		params.merge!(namespace: namespace)
		params.merge!(metric_name: metric_name) if metric_name.present?

		[namespace, "System/Linux"].each do |ns|
			config_details.merge!(
				metrics_details(params)[:result].inject({}) do |result, metric|
					result[metric[:metric_name]] ||= {}
					result[metric[:metric_name]].merge!(
						dimensions: metric[:dimensions].map {|dimension| {name: dimension[:name], value: dimension[:value]}}
					)
					result
				end
			)
		end
		config_details		
	end

end