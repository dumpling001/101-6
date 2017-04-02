class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :destroy]

  def new
    @movie = Movie.find(params[:movie_id])
    @post = Post.new
  end

  def edit
    @movie = Movie.find(params[:movie_id])
    if current_user != @group.user
      redirect_to root_path, alert: "你不是本电影成员！请加入后再发表评论"
    else
      @post = Post.find(params[:movie_id])
    end
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @post = Post.new(post_params)
    @post.movie = @movie
    @post.user = current_user

    if @post.save
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def destroy
    @post.destroy
    redirect_to movie_path(@movie), alert: "看法已删除！"
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

end
