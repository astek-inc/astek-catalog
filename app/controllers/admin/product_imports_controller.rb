class Admin::ProductImportsController < Admin::BaseController

  before_action :set_product_import, only: [:edit, :update, :destroy]

  def index
    @product_imports = ProductImport.page params[:page]
  end

  def new
    @product_import = ProductImport.new
  end

  def create
    @product_import = ProductImport.new(product_import_params)
    if @product_import.save
      flash[:notice] = 'Product import created.'
      redirect_to(action: 'index')
    else
      flash[:error] = error_message @product_import
      render('new')
    end
  end

  def edit

  end

  def update
    if @product_import.update(product_import_params)
      flash[:notice] = 'Product import updated.'
      redirect_to(action: 'index')
    else
      flash[:error] = error_message @product_import
      render('edit')
    end
  end

  def destroy
    @product_import.destroy
    flash[:notice] = 'Product import removed.'
    redirect_to(action: 'index')
  end

  private

  def set_product_import
    @product_import = ProductImport.find(params[:id])
  end

  def product_import_params
    params.require(:product_import).permit(:name, :file)
  end

end
