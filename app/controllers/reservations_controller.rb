# app/controllers/reservations_controller.rb
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
    @guests = params[:guests]
    
    if @check_in.present? && @check_out.present?
      @nights = (Date.parse(@check_out) - Date.parse(@check_in)).to_i
      @total_price = @room.price * @nights
    else
      redirect_to room_path(@room), alert: "日付を正しく入力してください"
    end
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
      redirect_to room_path(@room), alert: "予約に失敗しました"
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