class Room < ApplicationRecord
  
  belongs_to :user
  has_one_attached :image
  has_many :reservations, dependent: :destroy


  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :address, presence: true

end
