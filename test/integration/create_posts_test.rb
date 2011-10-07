require 'test_helper'

class PostsTest < ActionDispatch::IntegrationTest

  fixtures :all

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "create new post before login" do
    visit "/posts"
    click_link "Post a New Question"
    assert (current_path == "/signin")
    fill_in "session_password", :with=>"123456"
    fill_in "session_userName", :with=>users(:one).userName
    click_button "Sign in"
  end
end
