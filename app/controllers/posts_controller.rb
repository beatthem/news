# encoding: utf-8
class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :vote]
  def index
    @posts = Post.includes(:user).order("rating desc, created_at desc").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.includes(:user).order(:created_at).find(params[:id])
    @vote = Vote.find_by_post_id_and_user_id(@post.id, current_user.id)

    gon.post = @post
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = current_user.id
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Новость создана.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if current_user.id != @post.user_id
        format.html { redirect_to @post, notice: 'Нет прав' }
        #TODO:правильная выдача json
        format.json { render json: ["Нет прав"],
                      status: :unprocessable_entity }
      elsif @post.update_attributes(params[:post])
        format.html { redirect_to @post,
                      notice: 'Новость была обновлена.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])
    if current_user.id != @post.user_id
      respond_to do |format|
        format.html { redirect_to @post, :notice => 'Нет прав' }
      end
    end
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def vote
    @success = false
    @rating = 0
    @vote_sign = ''
    @vote_type = params[:vote_type]
    ActiveRecord::Base.transaction do
      if @vote_type == "upvote" || @vote_type == "downvote"
        @vote_boolean = @vote_type == "upvote" ? true : false
        @vote_sign = @vote_boolean ? '+' : '-'
        @vote_integer = @vote_boolean ? 1 : -1
        @post = Post.find(params[:post_id])
        if @post
          if !vote_exists?(params[:post_id], current_user.id)

            @vote = Vote.new
            @vote.post_id = params[:post_id]
            @vote.user_id = current_user.id
            @vote.positive = @vote_integer
            @vote.save
            @rating = @post.rating || 0
            Post.update(@post.id,
                        :rating => (@post.rating || 0) + @vote_integer)
            @rating += @vote_integer
            if @vote
              @success = true
            end
          end
        end
      end
    end
    respond_to do |format|
      format.json {render json: {
        :success => @success, :vote_sign => @vote_sign,
        :rating => @rating
      }}
    end
  end
  def vote_exists?(post_id, user_id)
    @vote = Vote.find_by_post_id_and_user_id(post_id, user_id)
    if @vote != nil
      return true
    end
    return false
  end

end
