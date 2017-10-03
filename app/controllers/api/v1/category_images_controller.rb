module Api
  module V1
    class CategoryImagesController < ::ApplicationController

      def create
        @category_image = CategoryImage.new(category_image_params)
        if @category_image.save!
          render json: @category_image, status: :created
        else

        end
      end

      def update
        @category_image = Image.find(params[:id])
        if @category.update_attributes(category_params)
          render json: @category_image, status: :ok
        else
          raise 'Error trying to update category'
        end
      end

      def destroy
        @category_image = Image.find(params[:id])

        @category_image.destroy!
        render json: { message: 'Category image deleted' }, status: :ok
      end

      private

      def category_image_params
        params.require(:category_image).permit(:file, :type, :owner_id)
      end

    end
  end
end
