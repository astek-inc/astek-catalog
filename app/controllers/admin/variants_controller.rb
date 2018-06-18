module Admin
  class VariantsController < Admin::BaseController

    before_action :get_design, :get_collection
    before_action :get_colors, only: [:new, :edit]

    def index
      @variants = Variant.where(design_id: @design.id).rank(:row_order).page params[:page]
      @position_start = (@variants.current_page.present? ? @variants.current_page - 1 : 0) * @variants.limit_value
    end

    def new
      @variant = Variant.new
    end

    def create
      @variant = Variant.new(variant_params)
      if @variant.save
        flash[:notice] = 'Variant created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @variant = Variant.friendly.find(params[:id])
      # @collection = @variant.collection
    end

    def update
      @variant = Variant.friendly.find(params[:id])
      if @variant.update_attributes(variant_params)
        flash[:notice] = 'Variant updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @variant = Variant.friendly.find(params[:id])
    end

    def update_row_order
      @variant = Variant.find(params[:item_id])
      @variant.row_order_position = params[:row_order_position]
      @variant.save

      render nothing: true
    end

    def destroy
      Variant.friendly.find(params[:id]).destroy
      flash[:notice] = 'Variant destroyed.'
      redirect_to(action: 'index')
    end

    private

    def get_design
      @design = Design.friendly.find(params[:design_id])
    end

    def get_collection
      @collection = @design.collection
    end

    def get_colors
      @colors = Color.rank(:row_order)
    end

    def variant_params
      params.require(:variant).permit(:variant_type_id, :name, :sku, :price_code, :keywords, :slug, :design_id, color_ids: [])
    end

  end
end
