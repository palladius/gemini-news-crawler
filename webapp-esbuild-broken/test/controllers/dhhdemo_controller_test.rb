require "test_helper"

class DhhdemoControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get dhhdemo_show_url
    assert_response :success
  end
end
