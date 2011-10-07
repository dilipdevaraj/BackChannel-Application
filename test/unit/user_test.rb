require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users
  test "the truth" do
    assert true
  end

  test "no username" do
   user = User.new
   assert !user.valid?
 end

  test "authenticate user" do
    user_param = {:userName => "dilipdevaraj",:email => "xx@yz.com", :password => "123456", :password_confirmation => "123456"}
    @userNew = User.new(user_param)
    @userNew.user_type = "user"
    @userNew.save

    #assert that this new user can be authenticated
    assert User.authenticate(@userNew.userName, @userNew.password)
  end

  test "should require all fields" do
  u = User.new
  assert_false u.valid?
  end
end
