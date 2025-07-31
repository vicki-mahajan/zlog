class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @posts = user_signed_in? ? Post.all : Post.published
  
    if params[:query].present?
      query = "%#{params[:query]}%"
      @posts = @posts.where("title ILIKE ? OR body ILIKE ?", query, query)
    end
  
    if params[:published_only].present?
      @posts = @posts.published
    end

    if params[:draft_only].present?
      @posts = @posts.draft
    end
  
    if params[:own_posts_only].present? && user_signed_in?
      @posts = @posts.where(user_id: current_user.id)
    end
  
    if params[:start_date].present?
      @posts = @posts.where("created_at >= ?", Date.parse(params[:start_date]))
    end
  
    if params[:end_date].present?
      @posts = @posts.where("created_at <= ?", Date.parse(params[:end_date]).end_of_day)
    end
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
  
    if params[:query].present?
      query = "%#{params[:query]}%"
      @posts = @posts.where("title ILIKE ? OR body ILIKE ?", query, query)
    end
  
    if params[:published_only].present?
      @posts = @posts.published
    end
  
    if params[:draft_only].present?
      @posts = @posts.draft
    end
  
    if params[:start_date].present?
      @posts = @posts.where("created_at >= ?", Date.parse(params[:start_date]))
    end
  
    if params[:end_date].present?
      @posts = @posts.where("created_at <= ?", Date.parse(params[:end_date]).end_of_day)
    end
  
    render :index
  end  

  private

  def post_params
    params.require(:post).permit(:title, :body, :status)
  end
end
