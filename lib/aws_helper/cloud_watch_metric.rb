class AwsHelper::CloudWatchMetric < AwsHelper::CloudWatch

	def initialize(server_access_token, namespace, metric_name)	
		super(server_access_token)
		@metric = Aws::CloudWatch::Metric.new(namespace, metric_name, {client: @cloudwatch})
		@namespace = namespace
		@metric_name = metric_name
	end

	def statistics_datapoints(params)
		begin 
			# Validate collection of DIMENTIONS for specified METRIC-NAME
			validation_result = validate_dimensions(params[:dimensions])
			if validation_result[:error].present?
				return {error: {code: I18n.t("aws.cloud_watch.codes.invalid_argument"), message: validation_result[:error][:message]}, result: []} 
			end
			## Note: 
			# UNIT valus depends on METRIC, hence, can not be set to default if user does not provide.
			params[:start_time] = Time.now-1.hours if params[:start_time].blank?
			params[:end_time] = Time.now if params[:end_time].blank?
			params[:period] = 3600 if params[:period].blank?
	
			# Fetch statistics datapoints
			result = @metric.get_statistics(params).datapoints
			return {error: {}, result: result}
		rescue Aws::CloudWatch::Errors::InvalidParameterValue => e
			return {error: {code: e.code.to_s, message: e.message}, result: []}
		rescue ArgumentError => e
			return {error: {code: I18n.t("aws.cloud_watch.codes.invalid_argument"), message: e.message}, result: []}
		# rescue Exception => e
		# 	return {error: {code: I18n.t("aws.common.codes.custom_exception"), message: I18n.t("aws.common.errors.custom_exception")}, result: []}
		end
	end

	private

	## Note:
	# Insted of throwing Error, AWS API returns []-blank datapoints, if all DIMETIONES with METRIC-NAME are not passed
	# Hence, added this custom validation
	# i.e, 
	#	for METRIC-NAME=DiskSpaceUtilization, passing only InstanceId as DIMENSIONS returns []-blank datapoints
	# it requires Filesystem and MountPath, too in DIMENTIONS collection
	#
	def validate_dimensions(dimensions)
		metric_dimensions = metrics_config_details(@namespace, @metric_name)[@metric_name][:dimensions].map {|md| md[:name]}
		if (metric_dimensions & dimensions.map {|d| d[:name]}) != metric_dimensions
			return {error: {message: I18n.t("aws.cloud_watch.errors.invalid_dimensions", metric_name: @metric_name, dimensions: metric_dimensions)}}
		end
		{error: {}}
	end

end