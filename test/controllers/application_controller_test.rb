require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  skip
  test "#index without token in header" do
    get 'index'
    assert response.status == 401
  end

  test "#index with invalid token" do
    skip
    get 'index', {}, { 'Authorization' => "Bearer 12345" }
    assert response.status == 401
  end

  test "#index with expired token" do
    skip
    joe = users(:joe)
    expired_api_key = joe.api_keys.session.create
    expired_api_key.update_attribute(:expired_at, 30.days.ago)
    assert !ApiKey.active.map(&:id).include?(expired_api_key.id)
    get 'index', {}, { 'Authorization' => "Bearer #{expired_api_key.access_token}" }
    assert response.status == 401
  end

  test "#index with valid token" do
    skip
    joe = users(:joe)
    api_key = joe.session_api_key
    get 'index', {}, { 'Authorization' => "Bearer #{api_key.access_token}" }
    results = JSON.parse(response.body)
    assert results['users'].size == 2
  end

end