class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :guests, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  
  validate :check_out_after_check_in
  validate :check_in_not_in_past

  private

  def check_out_after_check_in
    return if check_in.blank? || check_out.blank?

    if check_out <= check_in
      errors.add(:check_out, "はチェックイン日より後の日付を選択してください")
    end
  end

  def check_in_not_in_past
    return if check_in.blank?

    if check_in < Date.today
      errors.add(:check_in, "は本日以降の日付を選択してください")
    end
  end
end