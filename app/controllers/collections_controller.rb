class CollectionsController < ApplicationController
  def index
    @collections = Collection.page(params[:page]).per(30)
  end

  def show
    @collection = Collection.find(params[:id])
  end
end
