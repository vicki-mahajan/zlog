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
      return
    end

    @messages = @conversation.messages.includes(:user).order(created_at: :asc).last(20)
    @old_messages_exist = @conversation.messages.size > 20
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

  def load_older_messages
    @conversation = Conversation.find(params[:id])
    before_id = params[:before_id]
    @messages = @conversation.messages.where("id < ?", before_id).includes(:user).order(created_at: :asc).last(20)
    @old_messages_exist = @conversation.messages.where("id < ?", @messages.first.id).exists?
    @new_message = Message.new
  end
end
