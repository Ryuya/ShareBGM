require 'test_helper'

class MovieUrlsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get movie_urls_index_url
    assert_response :success
  end

end
