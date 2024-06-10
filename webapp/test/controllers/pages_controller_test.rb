# frozen_string_literal: true

require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get stats' do
    get pages_stats_url
    assert_response :success
  end

  test 'should get about' do
    get pages_about_url
    assert_response :success
  end

  test 'should get search' do
    get pages_search_url
    assert_response :success
  end
end
