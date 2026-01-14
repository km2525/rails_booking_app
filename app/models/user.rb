class User < ApplicationRecord
  has_secure_password
  has_one_attached :icon

  has_many :rooms, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_one_attached :avatar  # 追加

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
