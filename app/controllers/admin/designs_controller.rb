module Admin
  class DesignsController < Admin::BaseController

    # def index
    #   # @designs = Design.page params[:page]
    #   # @position_start = (@designs.current_page.present? ? @designs.current_page - 1 : 0) * @designs.limit_value
    #   #
    #   @q = Design.ransack(params[:q])
    #   @designs = @q.result.includes(:variants).page(params[:page]).uniq
    # end

    def search
      @q = Design.ransack(params[:q])
      @designs = @q.result.includes(:variants).page(params[:page]).uniq
    end

  end
end
