class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def authenticate
    authenticate_or_request_with_http_token do |token, options|
      # puts token
      # puts options
      token == ENV['SECRET_TOKEN']
    end
  end

  def not_found error
    render json: { error: error.message }, status: :not_found
  end

end
