class Micropost < ApplicationRecord
  belong_to :user
  validates :content, presence: true, length: {maximum: 140}

  scope :newest, ->{order created_at: desc}
end
