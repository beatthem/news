class UsersController < ApplicationController
  before_filter :authenticate_user!
  def all_posts
    @posts = Post.where(:user_id => current_user.id)
  end
end
