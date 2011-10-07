class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json

  def index
    @posts = Post.find_all_by_postId(nil)
    @title = 'Back Channel App - Home'
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    if signed_in?
      @post = Post.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @post }
      end
    else
      redirect_to '/signin' , :flash => {:info => "you have to signin before you can post!"}
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    if $current_user.nil? or $current_user.id != @post.user.id
      respond_to do |format|
        format.html {redirect_to '/posts', :flash => {:info => "You do not have the proper permissions for this operation"}}
      end
    end
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = $current_user.posts.build(params[:post]);
    respond_to do |format|
      if @post.save
        format.html { redirect_to :to => 'posts#index' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to '/posts', notice: 'Post was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy

    @post = Post.find(params[:id])
    @repliesToPost = Post.find_all_by_postId(@post.id)
    #delete each reply made to the post
    @repliesToPost.each do |eachReply|
      eachReply.destroy
    end

    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :ok }
    end
  end

  def reply
    if signed_in?

      @postid= params[:id]
      respond_to do |format|
        format.html
        format.json { render json: @post }
      end
    else
      respond_to do |format|
        format.html {redirect_to '/posts', :flash => {:info => "You have to sign in before you can reply"} }
      end
    end
  end

  def addReply
    @post = $current_user.posts.build(params[:post])
    @post.postId = params[:postId]
    respond_to do |format|
      if @post.save
        format.html { redirect_to '/posts'}
      end
    end
  end

  def search
    search_by =  params[:search_by]
    if(params[:search].to_s == "")
      respond_to do |format|
        format.html{redirect_to '/posts', :flash => {:info => "Search term cannot be empty"} }
      end
    else
      if search_by !="1" && search_by !="2"
        respond_to do |format|
          format.html{redirect_to '/posts', :flash => {:info => "Please check one of the radio buttons in search"} }
        end
      else
        if search_by =="1"  # search by post
          @posts = Array.new
          allposts = Post.all

          for eachpost in allposts do
            search_term = params[:search].to_s
            search_term_lower_case = search_term.downcase
            eachpost_description_lower_case = eachpost.description.downcase
            if(eachpost_description_lower_case.include?(search_term_lower_case))
              @posts << eachpost
            end
          end
        elsif search_by =="2"  # search by user
          @user = User.find_by_userName(params[:search])
          if @user.nil?
            @posts = Array.new
          else
            @posts = Post.find_all_by_user_id(@user.id)
          end
        end
        respond_to do |format|
          format.html  # search.html.erb
          format.json { render json: @posts }
        end
      end
    end
  end

end
