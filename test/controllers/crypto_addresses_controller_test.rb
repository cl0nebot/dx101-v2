require 'test_helper'

class CryptoAddressesControllerTest < ActionController::TestCase
  setup do
    @crypto_address = crypto_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:crypto_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create crypto_address" do
    assert_difference('CryptoAddress.count') do
      post :create, crypto_address: { active: @crypto_address.active, address: @crypto_address.address, addrtype: @crypto_address.addrtype, currency: @crypto_address.currency, user_id: @crypto_address.user_id }
    end

    assert_redirected_to crypto_address_path(assigns(:crypto_address))
  end

  test "should show crypto_address" do
    get :show, id: @crypto_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @crypto_address
    assert_response :success
  end

  test "should update crypto_address" do
    patch :update, id: @crypto_address, crypto_address: { active: @crypto_address.active, address: @crypto_address.address, addrtype: @crypto_address.addrtype, currency: @crypto_address.currency, user_id: @crypto_address.user_id }
    assert_redirected_to crypto_address_path(assigns(:crypto_address))
  end

  test "should destroy crypto_address" do
    assert_difference('CryptoAddress.count', -1) do
      delete :destroy, id: @crypto_address
    end

    assert_redirected_to crypto_addresses_path
  end
end
