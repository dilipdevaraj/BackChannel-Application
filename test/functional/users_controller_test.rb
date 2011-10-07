require 'test_helper'
require_relative '../../app/helpers/sessions_helper'

class UsersControllerTest < ActionController::TestCase
include SessionsHelper
  setup do
    @user = users(:one)
  end

  test "should display index when logged in as admin" do
    u1 = User.new
    u1.id = 10
    u1.user_type = "Admin"
    u1.salt = 10
    u1.email = "a@b.com"
    setcurruser(u1)
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should show user" do
    get :show, id: @user.id
    assert_redirected_to('/signin')
  end

  test "should update user" do
    put :update, id: @user.to_param, user: @user.attributes
    assert_response :success
  end

test "no_username" do
   user = User.new
   assert !user.valid?
 end

 test "username_not_unique" do
   user = User.new
   user.userName = users(:one).userName
   user.password = "123"
   user.id = (4)
   user.email = "dilip@abc.com"
   assert !user.valid?

 end

 test "password is encrypted" do
   user = User.new
   user.userName = "john"
   user.email = "bb@c.com"
   user.password = "smith"
   user.save
   assert_not_equal(user.encrypted_password, user.password, "password should be encrypted" )
 end

test "only admin can delete user accounts" do
  @user = users(:one)
  assert_difference('User.count', -1) do
    delete :destroy, :id => users(:two).id
  end
end


end
