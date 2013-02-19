require 'test_helper'

class ApiControllerTest < ActionController::TestCase

  test "should be able to create a message" do
    assert_difference('Message.count') do
      post :create_message, format: :json, 
                            message: { :body => 'Message body', :encrypted_passphrase => 'apples99'}
      assert_response :success
      response_json = JSON.parse(@response.body)
      assert_equal 'true', response_json['created']
    end
  end

  test "should show an error when you try to view an invalid message" do
    get :view_message, format: :json,
                        :encrypted_passphrase => 'blah'
    assert_response :unprocessable_entity
    response_json = JSON.parse(@response.body)
    assert_equal 'message not found', response_json['error']
  end

  test "should be able to view a message (and it self-destructs immediately)" do
    assert_difference('Message.count') do
      post :create_message, format: :json, 
                          message: { :body => 'My message body', :encrypted_passphrase => 'foo52', :destroy_after => 0}
      assert_response :success
    end
    assert_difference('Message.count', -1) do
      get :view_message, format: :json,
                          :encrypted_passphrase => 'foo52'
      assert_response :success
      response_json = JSON.parse(@response.body)
      assert_equal 'My message body', response_json['message']
    end
  end

  test "should get banned after X failed attempts are reached" do
    1.upto(GANDHI_SETTINGS['ban_after_fail_attempts']) do |i|
      get :view_message, format: :json,
                          :encrypted_passphrase => "dictionary attack #{i}"
      assert_response :unprocessable_entity
      response_json = JSON.parse(@response.body)
      assert_equal 'message not found', response_json['error']
    end

    get :view_message, format: :json,
                        :encrypted_passphrase => "one too many dictionary attacks"
    assert_response :redirect
    assert_redirected_to '/500.html'

  end

end
