class ReadingsController < ApplicationController
  before_action :authenticate_user!


  def index
    @readings = current_user.readings.order(created_at: :desc)
    @total_hours = current_user.total_reading_hours         # ユーザー側のメソッドを呼び出す
    @avg_minutes = current_user.average_reading_minutes     # ユーザー側のメソッドを呼び出す
  end

  # これ以降の部分はgemini
  def create
    @reading = current_user.readings.build(reading_params)
    if @reading.save
      redirect_to readings_path, notice: "読書記録を保存しました"
    else
      redirect_to readings_path, alert: "保存に失敗しました"
    end
  end

  def destroy
    @reading = current_user.readings.find(params[:id])
    @reading.destroy
    redirect_to readings_path, notice: "記録を削除しました", status: :see_other
  end

  # タイマー開始
  def start
    if current_user.currently_reading
      redirect_to readings_path, alert: "すでに記録中のセッションがあります"
    else
      current_user.readings.create!(start_at: Time.current)
      redirect_to readings_path, notice: "読書時間の計測を開始しました！"
    end
  end

  # タイマー終了
  def finish
    reading = current_user.currently_reading
    if reading
      reading.update!(end_at: Time.current)
      redirect_to readings_path, notice: "読書を記録しました。お疲れ様でした！"
    else
      redirect_to readings_path, alert: "記録中のセッションが見つかりませんでした"
    end
  end

  private

  def reading_params
    params.require(:reading).permit(:start_at, :end_at)
  end
end
