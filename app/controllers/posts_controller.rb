class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json

  def index
    @posts = Post.find_all_by_postId(nil)
    @sortedpost = sortposts
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

  def sortposts
    # sorting the posts according to the weights
    sortedpost = Post.find_all_by_postId(nil)
    sortedpost.each do |post|
      vote_post = Vote.find_all_by_post_id(post.id)
      vote_count = vote_post.count
      time_difference_sec = Time.now.utc - post.created_at
      minutes  = time_difference_sec / 60
      hours = (minutes / 60).to_int
      days  = (hours / 24).to_int
      months = (days/30).to_int
      years =  (months/12).to_int
      score = 0

      if years > 0
        score = 0
      elsif months > 0
        if months < 3
          score = 4
        elsif months < 6
          score = 3
        elsif months < 9
          score = 2
        elsif months < 12
          score = 1
        end
      elsif days > 0
        if days < 5
          score = 10
        elsif days < 10
          score = 9
        elsif days < 15
          score = 8
        elsif days < 20
          score = 7
        elsif days < 25
          score = 6
        elsif days < 31
          score = 5
        end
      elsif hours > 0
        if hours < 4
          score = 16
        elsif hours < 8
          score = 15
        elsif hours < 12
          score = 14
        elsif hours < 16
          score = 13
        elsif hours < 20
          score = 12
        elsif hours < 24
          score = 11
        end
      elsif minutes > 0
        if minutes < 1
          score = 36
        elsif minutes < 2
          score = 35
        elsif minutes < 3
          score = 34
        elsif minutes < 4
          score = 33
        elsif minutes < 5
          score = 32
        elsif minutes < 6
          score = 31
        elsif minutes < 7
          score = 30
        elsif minutes < 8
          score = 29
        elsif minutes < 9
          score = 28
        elsif minutes < 10
          score = 27
        elsif minutes < 15
          score = 26
        elsif minutes < 20
          score = 25
        elsif minutes < 25
          score = 24
        elsif minutes < 30
          score = 23
        elsif minutes < 35
          score = 22
        elsif minutes < 40
          score = 21
        elsif minutes < 45
          score = 20
        elsif minutes < 50
          score = 19
        elsif minutes < 55
          score = 18
        elsif minutes < 60
          score = 17
        end
      else
        score = 37


      end
      post.weight = vote_count * 60 + 40 * score
      post.save

    end

    return sortedpost
  end

end
