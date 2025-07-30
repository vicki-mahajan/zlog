class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = Post.published
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post, notice: "Post created successfully."
    else
      render :new
    end
  end

  def edit
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to posts_path, alert: "You can only edit your own posts." unless @post
  end
  
  def update
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: "You can only update your own posts."
      return
    end
  
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to posts_path, alert: "You can only delete your own posts."
      return
    end
  
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  def dashboard
    @posts = current_user.posts
    render :index
  end  

  private

  def post_params
    params.require(:post).permit(:title, :body, :status)
  end
end
