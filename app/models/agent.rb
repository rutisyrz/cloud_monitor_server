class Agent
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :aws_region, type: String
  field :aws_access_key, type: String
  field :aws_secret, type: String
  field :server_access_token, type: String

  validates :name, :aws_region, :aws_access_key, :aws_secret, :server_access_token, presence: true

  index( {server_access_token: 1}, {:background => true} )
  index( {aws_region: 1, aws_access_key: 1, aws_secret: 1}, { unique: true } )


  class << self
  	def aws_data(access_token)
  		where(server_access_token: access_token).first
  	end
  end
end
