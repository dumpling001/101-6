module Account::PostsHelper
  def render_movie_description(post)
   simple_format(post.description)
  end
end
