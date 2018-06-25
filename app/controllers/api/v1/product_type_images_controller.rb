module Api
  module V1
    class ProductTypeImagesController < BaseController

      # def index
      #   @product_type = ProductType.friendly.find(params[:product_type_id])
      #   @product_type_images = ProductTypeImage.find_by(owner_id: @product_type.id)
      #   if @product_type_images
      #     render json: @product_type_images
      #   else
      #     render json: { message: 'No images are available for this catagory' }, status: :not_found
      #   end
      # end

      def create
        @product_type_image = ProductTypeImage.new(product_type_image_params)
        if @product_type_image.save!
          render json: @product_type_image, status: :created
        else
          render json: { message: 'Error creating product_type image' }, status: :internal_server_error
        end
      end

      def destroy
        @product_type_image = Image.find(params[:id])

        @product_type_image.destroy!
        render json: { message: 'ProductType image deleted' }
      end

      private

      def product_type_image_params
        params.require(:product_type_image).permit(:file, :type, :owner_id)
      end

    end
  end
end
