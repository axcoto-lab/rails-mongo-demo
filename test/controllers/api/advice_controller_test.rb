require 'test_helper'

class Api::AdviceControllerTest < ActionController::TestCase
  setup do
    @advice_criteria = {
      diameter: 20,
      lat: 37.9578,
      long: -122.4376,
      user_id: 1,
      skin_type: 'normal'
    }
  end

  test 'show 404 when no param' do
    get :show
    assert_response :not_found
  end

  test 'get advice sucesfully' do
    Advice.stub :find, 'advice' do
      get :show, @advice_criteria
      assert_response :success
      assert_equal 'advice', @response.body
    end
  end
end
