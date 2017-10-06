module Api
  module V1
    class CategoryImagesController < BaseController

      # def index
      #   @category = Category.friendly.find(params[:category_id])
      #   @category_images = CategoryImage.find_by(owner_id: @category.id)
      #   if @category_images
      #     render json: @category_images
      #   else
      #     render json: { message: 'No images are available for this catagory' }, status: :not_found
      #   end
      # end

      def create
        @category_image = CategoryImage.new(category_image_params)
        if @category_image.save!
          render json: @category_image, status: :created
        else
          render json: { message: 'Error creating category image' }, status: :internal_server_error
        end
      end

      def destroy
        @category_image = Image.find(params[:id])

        @category_image.destroy!
        render json: { message: 'Category image deleted' }
      end

      private

      def category_image_params
        params.require(:category_image).permit(:file, :type, :owner_id)
      end

    end
  end
end
