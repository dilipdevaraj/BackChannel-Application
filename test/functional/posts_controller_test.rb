require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  fixtures :posts
  fixtures :users


  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:posts)
  end


  test "non user can see posts" do
    $current_user = nil
    get :index
    assert_response :success
  end


  test "invalid with empty description" do
    post = Post.new
    assert !post.valid?
  end

end
