module Admin
  class CollectionDesignsController < Admin::BaseController

    before_action :set_collection, except: [:edit]
    before_action :set_product_types, :set_sale_units, :set_styles, only: [:new, :edit]

    def index
      @designs = Design.where(collection_id: @collection.id).rank(:row_order).page params[:page]
      @position_start = (@designs.current_page.present? ? @designs.current_page - 1 : 0) * @designs.limit_value
    end

    def new
      @design = Design.new
    end

    def create
      @design = Design.new(design_params)
      if @design.save
        flash[:notice] = 'Design created.'
        redirect_to(action: 'index')
      else
        if @design.errors.any?
          msg = @design.errors.full_messages.join(', ')
        else
          msg = 'Error creating design.'
        end
        flash[:error] = msg
        render('new')
      end
    end

    def edit
      @design = Design.friendly.find(params[:id])
      @collection = @design.collection
    end

    def update
      @design = Design.friendly.find(params[:id])
      if @design.update_attributes(design_params)
        flash[:notice] = 'Design updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @design = Design.friendly.find(params[:id])
    end

    def update_row_order
      @design = Design.find(params[:item_id])
      @design.row_order_position = params[:row_order_position]
      @design.save

      render nothing: true
    end

    def destroy
      Design.friendly.find(params[:id]).destroy
      flash[:notice] = "Design destroyed."
      redirect_to(action: 'index')
    end

    private

    def set_collection
      @collection = Collection.friendly.find(params[:collection_id])
    end

    def set_product_types
      @product_types = ProductType.rank(:row_order)
    end

    def set_sale_units
      @sale_units = SaleUnit.all
    end

    def set_styles
      @styles = Style.all
    end

    def design_params
      params.require(:design).permit(:name, :description, :keywords, :slug, :collection_id, :price, :product_type_id, :sale_unit_id, :weight, :available_on, :expires_on, style_ids: [])
    end

  end

end
