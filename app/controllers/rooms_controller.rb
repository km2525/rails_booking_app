class RoomsController < ApplicationController
  before_action :require_login, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_room, only: [:edit, :update, :destroy]
  before_action :authorize_room!, only: [:edit, :update, :destroy]

  def index
  @rooms = Room.all
  
  # エリア検索
  if params[:area].present?
    area_query = "%#{params[:area]}%"
    @rooms = @rooms.where("address LIKE ?", area_query)
  end
  
  # キーワード検索
  if params[:keyword].present?
    keyword_query = "%#{params[:keyword]}%"
    @rooms = @rooms.where("name LIKE ? OR description LIKE ?", keyword_query, keyword_query)
  end
  
  # 古い検索パラメータとの互換性
  if params[:q].present? && params[:area].blank? && params[:keyword].blank?
    query = "%#{params[:q]}%"
    @rooms = @rooms.where("address LIKE ? OR name LIKE ?", query, query)
    @search_query = params[:q]
  end
end

  def my_rooms
    @rooms = current_user.rooms.order(created_at: :desc)
  end


  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @room.user_id = current_user.id  # 現在のユーザーに紐付け
    
    if @room.save
      redirect_to room_path(@room), notice: "施設を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @room = Room.find(params[:id])
  end

  def edit
  @room = Room.find(params[:id])
  # 自分の施設かチェック（オプション）
  unless @room.user_id == current_user.id
    redirect_to my_rooms_rooms_path, alert: "編集権限がありません"
  end
  end


  def update
  @room = Room.find(params[:id])
  
  # 自分の施設かチェック（オプション）
  unless @room.user_id == current_user.id
    redirect_to my_rooms_rooms_path, alert: "編集権限がありません"
    return
  end
  
  if @room.update(room_params)
    redirect_to my_rooms_rooms_path, notice: "施設を更新しました"
  else
    render :edit, status: :unprocessable_entity
  end
  end

  def destroy
    @room = Room.find(params[:id])
    @room.destroy
    redirect_to rooms_path, notice: "施設を削除しました"
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def authorize_room!
    redirect_to rooms_path, alert: "権限がありません" unless @room.user == current_user
  end

  def room_params
    params.require(:room).permit(:name, :description, :price, :address, :image)
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください"
    end
  end

end

