module Admin
  class DesignsController < Admin::BaseController

    def index
      # @designs = Design.page params[:page]
      # @position_start = (@designs.current_page.present? ? @designs.current_page - 1 : 0) * @designs.limit_value
      #
      @q = Design.ransack(params[:q])
      @designs = @q.result.includes(:variants).page(params[:page]).uniq
    end
    
    def search
      @designs = Design.available.where('name LIKE ?', params[:term] + '%')
      @designs.reject { |d| d.collection.websites.map { |w| w.id }.include? params[:website_id] }

      render json: @designs, each_serializer: DesignSearchResultSerializer, root: nil, adapter: :attributes
      # render json: @collections.map { |c| { id: c.id, value: c.name } }.to_json
    end

  end
end
