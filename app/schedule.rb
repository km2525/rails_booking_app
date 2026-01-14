class Schedule < ApplicationRecord
  # 必須項目
  validates :title, presence: true, length: { maximum: 20 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  # メモは任意・最大500文字
  validates :memo, length: { maximum: 500 }, allow_blank: true

  # 開始日 <= 終了日
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "は開始日以降の日付を選択してください")
    end
  end
end
