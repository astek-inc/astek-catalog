module Api
  module V1
    class CategoriesController < ::ApplicationController

      def index
        @categories = Category.rank(:row_order).all
        @categories.map.with_index { |category, i| prepare_for_display(category, i) }
        render json: @categories
      end

      def create
        @category = Category.new(category_params)
        @category.save!
        render json: @category
      end

      def show
        @category = Category.friendly.find(params[:id])
        @category = prepare_for_display@category
        render json: @category
      end

      def update
        @category = Category.friendly.find(params[:id])
        if @category.update_attributes(category_params)
          @category = prepare_for_display@category
          render json: @category
        else
          raise 'Error trying to update category'
        end
      end

      # def update_row_order
      #   @category = Category.find(params[:item_id])
      #   @category.row_order_position = params[:row_order_position]
      #   @category.save
      #
      #   render nothing: true
      # end

      def destroy
        Category.friendly.find(params[:id]).destroy
      end

      private

      def category_params
        params.require(:category).permit(:name, :description, :keywords, :slug, :row_order_position)
      end

      def prepare_for_display category, index = nil
        category.link = api_v1_category_path category
        category.row_order_position = index
        category
      end

    end
  end
end
