 # app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :require_login, only: [:settings, :account, :update_account, :profile, :update_profile, :edit, :update]
  before_action :set_user, only: [:edit, :update, :profile, :update_profile]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "アカウントを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def settings
    redirect_to account_settings_path
  end

  def account
    @user = current_user
  end

  def update_account
    @user = current_user
    
    # 現在のパスワードの確認
    if params[:user][:current_password].present?
      unless @user.authenticate(params[:user][:current_password])
        @user.errors.add(:current_password, "が正しくありません")
        render :account, status: :unprocessable_entity
        return
      end
    end
    
    # パスワード変更の処理
    if params[:user][:password].present?
      if @user.update(account_params_with_password)
        redirect_to account_settings_path, notice: "アカウント情報を更新しました"
      else
        render :account, status: :unprocessable_entity
      end
    else
      if @user.update(email: params[:user][:email])
        redirect_to account_settings_path, notice: "アカウント情報を更新しました"
      else
        render :account, status: :unprocessable_entity
      end
    end
  end

  def profile
    # @user は before_action で設定される
  end

  def update_profile
    # @user は before_action で設定される
    if @user.update(profile_params)
      redirect_to profile_settings_path, notice: "プロフィールを更新しました"
    else
      render :profile, status: :unprocessable_entity
    end
  end

  def edit
    @user = current_user
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "プロフィールを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_params_with_password
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:name, :bio, :avatar)
  end

  def set_user
    @user = current_user
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください"
    end
  end
end
 


 

 


 