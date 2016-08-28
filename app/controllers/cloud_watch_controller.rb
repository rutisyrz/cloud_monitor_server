class CloudWatchController < ApplicationController

  before_action :validate_agent_app_and_set_aws_access_details
  before_action :decode_params
  
  def statistics
		result = 	AwsHelper::CloudWatchMetric.new(params[:server_access_token], params[:namespace], params[:metric_name]).statistics_datapoints({
								dimensions: params[:dimensions], 
								start_time: params[:start_time], 
								end_time: params[:end_time], 
								period: params[:period], 
								statistics: params[:statistics], 
								unit: params[:unit] 
							})  
		render json: result, status: 200	
  end

  def metrics

  end

end
