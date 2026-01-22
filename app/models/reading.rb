class Reading < ApplicationRecord
  belongs_to :user

  # ここはgemini頼り
  validates :start_at, presence: true
  # ↓ ここから presence: true を削除
  # 終了時間がある場合のみ、開始時間より後であることをチェック
  validate :end_at_must_be_after_start_at, if: -> { end_at.present? }

  def duration_minutes
    return 0 unless start_at && end_at
    ((end_at - start_at) / 60).to_i
  end

  private

  def end_at_must_be_after_start_at
    if end_at <= start_at
      errors.add(:end_at, "は開始時間より後の時間である必要があります")
    end
  end
end
