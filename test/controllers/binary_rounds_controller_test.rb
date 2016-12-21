require 'test_helper'

class BinaryRoundsControllerTest < ActionController::TestCase
  setup do
    @binary_round = binary_rounds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:binary_rounds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create binary_round" do
    assert_difference('BinaryRound.count') do
      post :create, binary_round: { close: @binary_round.close, itm: @binary_round.itm, open: @binary_round.open, status: @binary_round.status }
    end

    assert_redirected_to binary_round_path(assigns(:binary_round))
  end

  test "should show binary_round" do
    get :show, id: @binary_round
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @binary_round
    assert_response :success
  end

  test "should update binary_round" do
    patch :update, id: @binary_round, binary_round: { close: @binary_round.close, itm: @binary_round.itm, open: @binary_round.open, status: @binary_round.status }
    assert_redirected_to binary_round_path(assigns(:binary_round))
  end

  test "should destroy binary_round" do
    assert_difference('BinaryRound.count', -1) do
      delete :destroy, id: @binary_round
    end

    assert_redirected_to binary_rounds_path
  end
end
