module Admin
  class UsersController < BaseController

    before_action :set_user, only: [:edit, :update, :delete, :destroy]

    def index
      @users = User.all
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save

        if params[:user][:is_admin] == '1'
          @user.add_role :admin
        else
          @user.remove_role :admin
        end

        flash[:notice] = 'User created.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @user
        render('new')
      end
    end

    def edit
    end

    def update
      if @user.update_attributes(user_params)
        if params[:user][:is_admin] == '1'
          @user.add_role :admin
        else
          @user.remove_role :admin
        end

        flash[:notice] = 'User updated.'
        redirect_to(action: 'index')
      else
        flash[:error] = error_message @user
        render('edit')
      end
    end

    def delete
    end

    def destroy
      @user.destroy
      flash[:notice] = 'User removed.'
      redirect_to(action: 'index')
    end

    private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :is_admin)
    end

  end
end
