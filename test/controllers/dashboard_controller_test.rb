require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get transactions" do
    get :transactions
    assert_response :success
  end

  test "should get deposit" do
    get :deposit
    assert_response :success
  end

  test "should get withdraw" do
    get :withdraw
    assert_response :success
  end

end
