class PostsController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :edit, :destroy]

  def new
    @movie = Movie.find(params[:movie_id])
    if current_user.is_member_of?(@movie) != true
      redirect_to movie_path(@movie), alert: "你没有收藏本电影！请收藏后再发表评论"
    else
      @post = Post.new
    end
  end

  def show
    @movie = Movie.find(params[:movie_id])
    @post = Post.find(params[:id])
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

  def update
    @movie = Movie.find(params[:movie_id])
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to movie_path(@movie), notice: "更新影评成功！"
    end
  end

  def edit
    @movie = Movie.find(params[:movie_id])
    @post = Post.find(params[:id])
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @post = Post.find(params[:id])
    if current_user.is_member_of?(@movie) != true
      redirect_to movie_path(@movie), alert: "你没有收藏本电影！请加入后再发表评论"
    else
    @post.destroy
      redirect_to movie_path(@movie), alert: "本篇影评已删除！"
    end
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

end
