module Api
  module V1
    class ProductTypesController < BaseController

      def index
        @product_types = ProductType.rank(:row_order).all
        render json: @product_types
      end

      # def create
      #   @product_type = ProductType.new(product_type_params)
      #   @product_type.save!
      #   render json: @product_type
      # end

      def show
        @product_type = ProductType.friendly.find(params[:id])
        render json: @product_type, include: [:product_type_images, :collections]
      end

      # def update
      #   @product_type = ProductType.friendly.find(params[:id])
      #   if @product_type.update_attributes(product_type_params)
      #     render json: @product_type
      #   else
      #     raise 'Error trying to update product_type'
      #   end
      # end

      # def destroy
      #   ProductType.friendly.find(params[:id]).destroy
      # end

      # private
      #
      # def product_type_params
      #   params.require(:product_type).permit(:name, :description, :keywords, :slug)
      # end

    end
  end
end
