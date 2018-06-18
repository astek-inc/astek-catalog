module Admin
  class CategoriesController < BaseController

    before_action :load_websites, only: [:new, :edit]

    def index
      @categories = Category.rank(:row_order).page params[:page]
      @position_start = (@categories.current_page.present? ? @categories.current_page - 1 : 0) * @categories.limit_value
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        flash[:notice] = 'Category created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @category = Category.friendly.find(params[:id])
    end

    def update
      @category = Category.friendly.find(params[:id])
      if @category.update_attributes(category_params)
        flash[:notice] = 'Category updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @category = Category.friendly.find(params[:id])
    end

    def update_row_order
      @category = Category.find(params[:item_id])
      @category.row_order_position = params[:row_order_position]
      @category.save

      render nothing: true
    end

    def destroy
      Category.friendly.find(params[:id]).destroy
      flash[:notice] = 'Category destroyed.'
      redirect_to(action: 'index')
    end

    private

    def load_websites
      @websites = Website.all
    end

    def category_params
      params.require(:category).permit(:name, :description, :keywords, :slug) #, image_attributes: [:file, :imageable_id, :image_type])
    end

  end

end
