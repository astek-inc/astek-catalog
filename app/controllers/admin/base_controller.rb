module Admin
  class BaseController < ApplicationController

    layout 'admin/application'

    # before_action :authenticate_user!, :authorize_admin

    def authorize_admin
      unless can? :manage, :all
        redirect_to :root
      end
    end

  end
end
