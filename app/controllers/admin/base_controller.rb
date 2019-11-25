module Admin
  class BaseController < ApplicationController

    before_action :set_q

    private

    def set_q
      @q = Design.search(params[:q])
    end

    def error_message model
      if model.errors.any?
        model.errors.full_messages.join(', ')
      else
        method_name = caller_locations.first.label
        "Error #{method_name.to_s.verb.conjugate(aspect: :progressive).sub(/^is /, '')} #{model.class.name.underscore.humanize.downcase}."
      end
    end

  end
end
