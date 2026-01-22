class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :libraries
  has_many :posts
  has_one_attached :avatar
  has_many :readings

  # ここ以降gemini頼り
  # 総読書時間（時間単位）
  def total_reading_hours
    # end_at が nil 以外のものだけで計算する
    completed_readings = readings.where.not(end_at: nil)
    total_seconds = completed_readings.sum { |r| r.end_at - r.start_at }
    (total_seconds / 3600).round(1)
  end

  # 1回あたりの平均読書時間（分単位）
  def average_reading_minutes
    completed_readings = readings.where.not(end_at: nil)
    return 0 if completed_readings.empty?

    total_minutes = completed_readings.sum(&:duration_minutes)
    (total_minutes / completed_readings.count).to_i
  end

  # 終了時間が空の記録（＝今読んでいる本）があるか確認
  def currently_reading
    readings.find_by(end_at: nil)
  end
end
