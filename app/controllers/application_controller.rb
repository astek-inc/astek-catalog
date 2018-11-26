class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # layout 'admin/application'

  before_action :authenticate_user!

  # , :authorize_admin

  def authorize_admin
    # unless can? :manage, :all
    # #   redirect_to :root
    # end

    # unless current_user.has_role :admin
    require 'pp'
    pp current_user
      # redirect_to :new_user_session
    # end
  end

end
