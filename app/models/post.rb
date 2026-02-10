class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_one_attached :image

  enum status: { draft: 0, published: 1 }

  validates :image, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: statuses.keys }

  private
end
