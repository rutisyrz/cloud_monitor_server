class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  # protect_from_forgery with: :exception  

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def validate_agent_app_and_set_aws_access_details
  	result = {error: {} }

  	if params[:server_access_token].blank?
  		result[:error] = {code: I18n.t("aws.common.codes.custom_exception"), message: I18n.t("aws.common.errors.missing_agent_token")}
  	else
  		aws_access_details = Agent.aws_data(params[:server_access_token])
  		unless aws_access_details.present?  		
  			result[:error] = {code: I18n.t("aws.common.codes.custom_exception"), message: I18n.t("aws.common.errors.missing_agent_token")}
  		end
  	end

  	render json: result, status: 404 and return if result[:error].present?
  end

  def decode_params
    arguments = Rack::Utils.parse_nested_query(request.query_parameters["arguments"])
    params.merge!(arguments)
  end

end