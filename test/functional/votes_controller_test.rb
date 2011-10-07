require 'test_helper'
require_relative '../../app/helpers/sessions_helper'

class VotesControllerTest < ActionController::TestCase
  include SessionsHelper
  fixtures :posts
  fixtures :users

  test "user cannot vote his own reply" do
    $current_user = users(:two)
    post = posts(:tworeply)
    get :handle, :id=> post.id

    assert_redirected_to(:controller => "posts")
    assert_equal 'You cannot vote for your own post ',flash[:info]
  end

  test "user cannot vote to post more than once" do
    $current_user = users(:two)
    get :handle, :id=>posts(:onepost).id
    get :handle, :id=>posts(:onepost).id
    assert_equal(flash[:info],"you have voted for this post already ")
  end

  test "user cannot vote his own post" do
    $current_user = users(:one)
    get :handle, :id=>posts(:onepost).id
    assert_redirected_to(:controller => "posts")
    assert_equal(flash[:info],"You cannot vote for your own post ")
  end

  test "user cannot vote to reply more than once" do
    $current_user = users(:one)
    get :handle, :id=>posts(:tworeply).id
    get :handle, :id=>posts(:tworeply).id
    assert_equal(flash[:info],"you have voted for this post already ")
  end

end
