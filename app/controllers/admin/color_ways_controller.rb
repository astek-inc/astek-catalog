module Admin
  class ColorWaysController < Admin::BaseController

    before_action :get_design, :get_collection

    def index
      @color_ways = ColorWay.where(design_id: @design.id).rank(:row_order).page params[:page]
      @position_start = (@color_ways.current_page.present? ? @color_ways.current_page - 1 : 0) * @color_ways.limit_value
    end

    def new
      @color_way = ColorWay.new
    end

    def create
      @color_way = ColorWay.new(color_way_params)
      if @color_way.save
        flash[:notice] = 'Color Way created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @color_way = ColorWay.friendly.find(params[:id])
      # @collection = @color_way.collection
    end

    def update
      @color_way = ColorWay.friendly.find(params[:id])
      if @color_way.update_attributes(color_way_params)
        flash[:notice] = 'Color Way updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @color_way = ColorWay.friendly.find(params[:id])
    end

    def update_row_order
      @color_way = ColorWay.find(params[:item_id])
      @color_way.row_order_position = params[:row_order_position]
      @color_way.save

      render nothing: true
    end

    def destroy
      ColorWay.friendly.find(params[:id]).destroy
      flash[:notice] = 'Color Way destroyed.'
      redirect_to(action: 'index')
    end

    private

    private

    def get_design
      @design = Design.friendly.find(params[:design_id])
    end

    def get_collection
      @collection = @design.collection
    end

    def color_way_params
      params.require(:color_way).permit(:name, :sku, :keywords, :slug, :design_id)
    end

  end
end
