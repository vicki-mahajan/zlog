class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_many :messages

  def conversation_with(other_user)
    conversations.includes(:users).find do |conv|
      conv.users.map(&:id).sort == [id, other_user.id].sort
    end
  end
end
