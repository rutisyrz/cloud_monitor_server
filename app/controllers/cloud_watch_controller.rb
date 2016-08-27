class CloudWatchController < ApplicationController

  before_action :validate_agent_app_and_set_aws_access_details
  before_action :decode_params
  
  def statistics
  	# http://127.0.0.1:4000/cloud_watch/statistics?server_access_token=e1a53bf4ef379af94cbac57f0d2fc2a2d&namespace=AWS/EC2&metric_name=CPUUtilization&dimensions%5B%5D%5Bname%5D=InstanceId&dimensions%5B%5D%5Bvalue%5D=i-0fac7a66328eb7396&statistics%5B%5D=Maximum&unit=Percent
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

  private

  def decode_params
  	params[:dimensions] = params[:dimensions].split("|").map {|d| t=d.split("^"); {"name" => t[0], "value" => t[1]} }
  	params[:statistics] = params[:statistics].split("|")
  end

end
