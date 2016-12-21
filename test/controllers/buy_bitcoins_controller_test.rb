require 'test_helper'

class BuyBitcoinsControllerTest < ActionController::TestCase
  setup do
    @buy_bitcoin = buy_bitcoins(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:buy_bitcoins)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create buy_bitcoin" do
    assert_difference('BuyBitcoin.count') do
      post :create, buy_bitcoin: { content: @buy_bitcoin.content, name: @buy_bitcoin.name, slug: @buy_bitcoin.slug }
    end

    assert_redirected_to buy_bitcoin_path(assigns(:buy_bitcoin))
  end

  test "should show buy_bitcoin" do
    get :show, id: @buy_bitcoin
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @buy_bitcoin
    assert_response :success
  end

  test "should update buy_bitcoin" do
    patch :update, id: @buy_bitcoin, buy_bitcoin: { content: @buy_bitcoin.content, name: @buy_bitcoin.name, slug: @buy_bitcoin.slug }
    assert_redirected_to buy_bitcoin_path(assigns(:buy_bitcoin))
  end

  test "should destroy buy_bitcoin" do
    assert_difference('BuyBitcoin.count', -1) do
      delete :destroy, id: @buy_bitcoin
    end

    assert_redirected_to buy_bitcoins_path
  end
end
