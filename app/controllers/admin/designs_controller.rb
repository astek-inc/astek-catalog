module Admin
  class DesignsController < Admin::BaseController

    def search
      @designs = Design.available.where('name LIKE ?', params[:term] + '%')
      @designs.reject { |d| d.collection.websites.map { |w| w.id }.include? params[:website_id] }

      render json: @designs, each_serializer: DesignSearchResultSerializer, root: nil, adapter: :attributes
      # render json: @collections.map { |c| { id: c.id, value: c.name } }.to_json
    end

  end
end
