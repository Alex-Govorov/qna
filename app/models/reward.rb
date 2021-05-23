class Reward < ApplicationRecord
  belongs_to :question
  has_one_attached :image

  validates :title, presence: true
  validates :image, presence: true
end
