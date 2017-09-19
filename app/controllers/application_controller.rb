class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      # puts token
      # puts options
      token == ENV['SECRET_TOKEN']
    end
  end

end
