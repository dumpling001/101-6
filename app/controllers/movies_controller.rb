class MoviesController < ApplicationController
  before_action :authenticate_user! ,only: [:new, :create, :edit, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy, :join, :quit]
  def index
  @movies = Movie.all
  end

 def show
  @movie = Movie.find(params[:id])
  @posts = @movie.posts.recent.paginate(:page => params[:page], :per_page => 5)
 end

 def edit
 end

  def new
    @movie = Movie.new
  end

  def create
   @movie = Movie.new(movie_params)
   @movie.user = current_user
   if @movie.save
     current_user.join!(@movie)
     redirect_to movies_path
   else
     render :new
   end
   end

   def update

     if @movie.update(movie_params)
      redirect_to movies_path, notice: '更新成功!'
    else
      render :edit
    end
   end

   def destroy

     @movie.destroy
     redirect_to movies_path, alert: "影评已删除!"
   end

  def join
   @movie = Movie.find(params[:id])

    if !current_user.is_member_of?(@movie)
      current_user.join!(@movie)
      flash[:notice] = "收藏电影成功！"
    else
      flash[:warning] = "你已经收藏过本电影了！"
    end

    redirect_to movie_path(@movie)
  end

  def quit
    @movie = Movie.find(params[:id])

    if current_user.is_member_of?(@movie)
      current_user.quit!(@movie)
      flash[:alert] = "已退出本电影！"
    else
      flash[:warning] = "你不是本电影成员。"
    end

    redirect_to movie_path(@movie)
  end


 private

 def find_movie_and_check_permission
   @movie = Movie.find(params[:id])

   if current_user != @movie.user
     redirect_to root_path, alert: "没有权限！"
   end
 end

 def movie_params
   params.require(:movie).permit(:title, :description)
 end
end
