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

    def csv_export_search
      domain = Website.find(params[:website_id]).domain
      @designs = Design.available.where('designs.name LIKE ?', params[:term] + '%').order('designs.name').joins(:collection).for_domain(domain)
      render json: @designs, each_serializer: DesignSearchResultSerializer, root: nil, adapter: :attributes
    end

    def design_alias_search
      @designs = Design.available.where('designs.name LIKE ? OR designs.sku LIKE ?', params[:term] + '%', params[:term] + '%').order('designs.name')
      render json: @designs, each_serializer: DesignSearchResultSerializer, root: nil, adapter: :attributes
    end

  end
end
