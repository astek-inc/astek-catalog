module Api
  module V1
    class CategoriesController < BaseController

      def index
        @categories = Category.rank(:row_order).all
        render json: @categories
      end

      # def create
      #   @category = Category.new(category_params)
      #   @category.save!
      #   render json: @category
      # end

      def show
        @category = Category.friendly.find(params[:id])
        render json: @category, include: [:category_images, :collections]
      end

      # def update
      #   @category = Category.friendly.find(params[:id])
      #   if @category.update_attributes(category_params)
      #     render json: @category
      #   else
      #     raise 'Error trying to update category'
      #   end
      # end

      # def destroy
      #   Category.friendly.find(params[:id]).destroy
      # end

      # private
      #
      # def category_params
      #   params.require(:category).permit(:name, :description, :keywords, :slug)
      # end

    end
  end
end
