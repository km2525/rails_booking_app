def create
  @user = User.new(user_params)

  Rails.logger.debug "USER VALID?: #{@user.valid?}"
  Rails.logger.debug "ERRORS: #{@user.errors.full_messages}"

  if @user.save
    session[:user_id] = @user.id
    redirect_to root_path, notice: "ユーザー登録が完了しました"
  else
    render :new
  end
end
