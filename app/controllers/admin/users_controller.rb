class Admin::UsersController < Admin::AdminController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.create(params[:user])
    if @user
      flash[:notice] = 'User created'
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    
    @user = User.find(params[:id])
    
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'User updated'
      redirect_to admin_users_path
    else
      render :action => 'edit'
    end

  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = 'User deleted'
    redirect_to admin_users_path
  end
end
