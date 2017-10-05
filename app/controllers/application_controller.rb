class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def authenticate
    # puts 'xxx'
    authenticate_or_request_with_http_token do |token, options|
      # puts token
      # puts ENV['SECRET_TOKEN']
      # puts options
      token == ENV['SECRET_TOKEN']
    end

  end

  # def authenticate
  #   puts 'xxx'
  #   authenticate_token # || render_unauthorized
  # end
  #
  # def authenticate_token
  #   authenticate_with_http_token do |token, options|
  #     puts token
  #     token == ENV['SECRET_TOKEN']
  #   end
  # end
  #
  # # def render_unauthorized
  # #   self.headers['WWW-Authenticate'] = 'Token realm="Application"'
  # #   render json: 'Bad credentials', status: 401
  # # end

  def not_found error
    render json: { error: error.message }, status: :not_found
  end

end
