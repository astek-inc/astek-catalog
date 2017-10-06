module Admin
  class DesignsController < Admin::BaseController

    before_action :set_collection

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
        render('new')
      end
    end

    def edit
      @design = Design.friendly.find(params[:id])
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

    def design_params
      params.require(:design).permit(:name, :description, :keywords, :slug, :collection_id, :image, :image_cache)
    end

  end

end
