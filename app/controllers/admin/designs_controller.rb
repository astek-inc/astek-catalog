module Admin
  class DesignsController < Admin::BaseController

    def search
      @designs = Design.page params[:page]
      # @position_start = (@designs.current_page.present? ? @designs.current_page - 1 : 0) * @designs.limit_value
    end

  end
end
