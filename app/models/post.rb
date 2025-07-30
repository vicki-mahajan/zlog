class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  enum status: { draft: 0, published: 1 }

  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: statuses.keys }

  before_validation :set_slug

  def to_param
    "#{id}-#{slug}"
  end

  private

  def set_slug
    self.slug = title.to_s.parameterize
  end
end
