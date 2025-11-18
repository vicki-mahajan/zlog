class ConversationsController < ApplicationController
  def index
    @conversations = current_user.conversations
                              .includes(:users, messages: :user)
                              .order(updated_at: :desc)
  end

  def show
    @conversation = Conversation.find(params[:id])

    unless @conversation.users.include?(current_user)
      redirect_to conversations_path, alert: "Not allowed"
    end

    @messages = @conversation.messages.includes(:user)
    @new_message = Message.new
  end

  def new
    @users = User.where.not(id: current_user.id)
  end

  def create
    other_user = User.find(params[:user_id])
    conversation = current_user.conversation_with(other_user)

    unless conversation
      conversation = Conversation.create!
      conversation.users << current_user
      conversation.users << other_user
    end

    redirect_to conversation_path(conversation)
  end
end
