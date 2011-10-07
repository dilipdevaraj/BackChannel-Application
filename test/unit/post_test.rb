require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "should require all fields" do
  p = Post.new
  assert_false p.valid?
  end

end
