
class ReservationsController < ApplicationController
  before_action :require_login

  def index
    @reservations = current_user.reservations.includes(:room).order(created_at: :desc)
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  
    def confirm
    @room = Room.find(params[:room_id])
    @check_in = params[:check_in]
    @check_out = params[:check_out]
    @guests = params[:guests].to_i
    
    # 日付のバリデーション
    if @check_in.blank? || @check_out.blank?
        redirect_to room_path(@room), alert: "日付を入力してください"
        return
    end
    
    check_in_date = Date.parse(@check_in)
    check_out_date = Date.parse(@check_out)
    
    # チェックアウトがチェックインより前の場合
    if check_out_date <= check_in_date
        redirect_to room_path(@room), alert: "チェックアウト日はチェックイン日より後の日付を選択してください"
        return
    end
    
    # 日数計算
    @nights = (check_out_date - check_in_date).to_i
    
    # 合計金額計算（1泊の料金 × 宿泊日数 × 人数）
    @total_price = @room.price * @nights * @guests
    rescue ArgumentError
    redirect_to room_path(@room), alert: "正しい日付を入力してください"
    end

  def rebook
    @reservation = current_user.reservations.find(params[:id])
    @room = @reservation.room
  end

  def create
    @room = Room.find(params[:room_id])
    @reservation = current_user.reservations.build(reservation_params)
    @reservation.room = @room
    
    nights = (@reservation.check_out - @reservation.check_in).to_i
    @reservation.total_price = @room.price * nights
    
    if @reservation.save
      redirect_to reservations_path, notice: "予約が完了しました"
    else
      redirect_to room_path(@room), alert: "予約に失敗しました: #{@reservation.errors.full_messages.join(', ')}"
    end
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    @reservation.destroy
    redirect_to reservations_path, notice: "予約をキャンセルしました"
  end

  private

  def reservation_params
    params.require(:reservation).permit(:check_in, :check_out, :guests)
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください"
    end
  end
end