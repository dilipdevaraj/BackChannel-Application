class VotesController < ApplicationController
  def handle
    @flag = 0
    @post = Post.find_by_id(params[:id])
    if $current_user.id != @post.user_id

      votecheck = Vote.find_by_post_id_and_user_id(@post.id,$current_user.id)
      if ( votecheck.nil?)
        voteForPost(@post)
        respond_to do |format|
          format.html{redirect_to '/posts', :flash => {:info => "Your vote has been registered"}}
        end
      else
        respond_to do |format|
          format.html{redirect_to '/posts', :flash => {:info => "you have voted for this post already "}}
        end
      end
    else
      respond_to do |format|
        format.html{redirect_to '/posts', :flash => {:info => "You cannot vote for your own post "}}
      end
    end
  end

  def voteForPost(post)
    @newVote = Vote.new
    @newVote.user_id = $current_user.id
    @newVote.post_id = @post.id
    @newVote.save
  end
  def showStats
     respond_to do |format|
       format.html{}
     end

  end

  def showHome
    redirect_to '/posts'
  end
end
