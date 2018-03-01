module Admin
  class ClientsController < Admin::BaseController

    def index
      @clients = Client.all
    end

    def new
      @client = Client.new
    end

    def create
      @client = Client.new(client_params)
      if @client.save
        flash[:notice] = 'Client created.'
        redirect_to(action: 'index')
      else
        render('new')
      end
    end

    def edit
      @client = Client.find(params[:id])
    end

    def update
      @client = Client.find(params[:id])
      if @client.update_attributes(client_params)
        flash[:notice] = 'Client updated.'
        redirect_to(action: 'index')
      else
        render('edit')
      end
    end

    def delete
      @client = Client.find(params[:id])
    end

    def destroy
      Client.find(params[:id]).destroy
      flash[:notice] = "Client destroyed."
      redirect_to(action: 'index')
    end

    def generate_token
      token = Client.generate_token
      render json: { token: token }
    end

    private

    def client_params
      params.require(:client).permit(:name, :domain, :token)
    end

  end
end
