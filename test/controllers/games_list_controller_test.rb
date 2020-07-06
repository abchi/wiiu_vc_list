require 'test_helper'

class GamesListControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get games_list_index_url
    assert_response :success
  end

end
