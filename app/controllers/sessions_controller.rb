class SessionsController < ApplicationController
  def new
    @title = 'Sign-in'
  end

  def create
    user = User.authenticate(params[:session][:userName],params[:session][:password])
    if user.nil?
      @title = "Sign in"
      respond_to do |format|
        format.html{redirect_to '/signin', :flash => {:info => "Invalid email/password combination."}}
      end
    else
      sign_in user
      if signed_in?
        respond_to do |format|
          format.html {redirect_to '/posts'}
        end
      end
    end
  end

  def destroy
    sign_out
    redirect_to '/posts'
  end

end


