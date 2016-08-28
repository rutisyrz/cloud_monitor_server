class Ec2Controller < ApplicationController

	before_action :validate_agent_app_and_set_aws_access_details
  before_action :decode_params

  def start
  	result = AwsHelper::EC2Instance.new(ec2_params[:server_access_token], ec2_params[:instance_id]).start
  	render json: result, status: 200
  end

  def stop
  	result = AwsHelper::EC2Instance.new(ec2_params[:server_access_token], ec2_params[:instance_id]).stop
  	render json: result, status: 200
  end

  def instance
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def ec2_params
    params.permit(:server_access_token, :instance_id)
  end
end
