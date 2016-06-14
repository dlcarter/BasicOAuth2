ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'
require './app/application.rb'

class AutherTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  USERNAME = "Sam #{rand}"
  PASSWORD = SecureRandom.hex 4

  def create_user
    post '/users', { name: "John Doe", username: USERNAME, password: PASSWORD }
  end

  def test_it_properly_authenticates_by_username
    create_user

    post '/token', { grant_type: "password", username: USERNAME, password: PASSWORD }
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    assert_equal 32, response["access_token"].length
    assert_equal 32, response["refresh_token"].length
  end

  def test_it_rejects_bad_credentials
    create_user
    
    post '/token', { grant_type: "password", username: USERNAME, password: "bad_password" }
    assert last_response.bad_request?
    response = JSON.parse(last_response.body)
    assert_equal "invalid_client", response["error"]
  end

  def test_it_properly_handles_refresh_auth
    create_user

    post '/token', { grant_type: "password", username: USERNAME, password: PASSWORD }
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    refresh_token = response["refresh_token"]
    
    post '/token', { grant_type: "refresh_token", refresh_token: refresh_token }
    assert last_response.ok?
    response = JSON.parse(last_response.body)
    refute_equal refresh_token, response["access_token"]
    refute_equal refresh_token, response["refresh_token"]
    assert_equal 32, response["access_token"].length
    assert_equal 32, response["refresh_token"].length

    post '/token', { grant_type: "refresh_token", refresh_token: "bad_token" }
    assert last_response.bad_request?
    response = JSON.parse(last_response.body)
    assert_equal "invalid_client", response["error"]
  end

end
