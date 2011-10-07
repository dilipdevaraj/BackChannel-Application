class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    if($current_user !=nil and $current_user.user_type == "Admin")
      @users = User.all
      respond_to do |format|
        format.html
        format.json { render json: @users }
      end
    else
      respond_to do |format|
        format.html {redirect_to '/posts', :flash=>{:info=>"you do not have permission to view this page"}}
        format.json { render json: @users }
      end
    end

  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    if $current_user.nil? or $current_user.id != @user.id
      redirect_to signin_path
    else
      @title = "#{@user.userName}'s profile"
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    if($current_user!=nil and $current_user.user_type == "user")
      respond_to do |format|
        format.html {redirect_to '/posts', :flash => {:info => "Cannot create new account. Please signout and try"}}
        format.json { render json: @user }
      end
    else
      @user = User.new
      @title = 'Sign-Up'
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    end
  end

  # GET /users/1/edit
  def edit
    @currentuser = params[:id].to_i
    if $current_user != nil and $current_user.id != @currentuser
      redirect_to '/posts', :flash => {:info => "You do not have the proper permissions for this operation"}
    else
      @user = User.find(params[:id])
    end
  end

  # POST /users
  # POST /users.json
  def create
    if(User.all.count==0 and $current_user==nil)
     @user = User.new(params[:user])
           @user.user_type="Admin"
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, :flash => {:info => 'Admin
successfully created.' }}
          format.json { render json: @user, status: :created, location: @user }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status:
              :unprocessable_entity }
        end
      end

    else if($current_user == nil)
           @user = User.new(params[:user])
           @user.user_type="user"
           respond_to do |format|
             if @user.save
               format.html { redirect_to @user, :flash => {:info =>
                                                               'Login was successfully created.' }}
               format.json { render json: @user, status: :created,
                                    location: @user }
             else
               format.html { render action: "new" }
               format.json { render json: @user.errors, status:
                   :unprocessable_entity }
             end
           end
         else
           if($current_user.user_type=="Admin")
             puts "creating new admin account"
             @user = User.new(params[:user])
             @user.user_type="Admin"
             respond_to do |format|
               if @user.save
                 format.html { redirect_to @user,:flash => {:info =>'Login was successfully created.' }}
                 format.json { render json: @user, status: :created,
                                      location: @user }
               else
                 format.html { render action: "new" }
                 format.json { render json: @user.errors, status:
                     :unprocessable_entity }
               end
             end
           end
         end
    end
  end


  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

    @user = User.find(params[:id])
    if $current_user == @user
      sign_out
    end
    #delete posts by user.
    @postsByUser = Post.find_all_by_user_id_and_postId(@user.id,nil)
    #iterate through each post
    @postsByUser.each do |post|
      @repliesToPost = Post.find_all_by_postId(post.id)
      #delete each reply made to the post
      @repliesToPost.each do |eachReply|
        eachReply.destroy
      end
    end
    #finally delete the user
    @user.destroy

    respond_to do |format|
      format.html { redirect_to '/posts' }
      format.json { head :ok }
    end
  end

  # link to display all posts by a user from user's home page
  # currently not working
  def showPosts
    @user = User.find_by_id(params[:id])
    respond_to do |format|
      format.html{render action: "show"}
    end
  end

  def showStats
    respond_to do|format|
      format.html{}
    end

  end
end
