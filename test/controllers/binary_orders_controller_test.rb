require 'test_helper'

class BinaryOrdersControllerTest < ActionController::TestCase
  setup do
    @binary_order = binary_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:binary_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create binary_order" do
    assert_difference('BinaryOrder.count') do
      post :create, binary_order: { affpay: @binary_order.affpay, depbonus: @binary_order.depbonus, itm: @binary_order.itm, itmpayout: @binary_order.itmpayout, direction: @binary_order.direction, pool: @binary_order.pool, prembalance: @binary_order.prembalance, premium: @binary_order.premium, profit: @binary_order.profit, sysbonus: @binary_order.sysbonus, user_id: @binary_order.user_id }
    end

    assert_redirected_to binary_order_path(assigns(:binary_order))
  end

  test "should show binary_order" do
    get :show, id: @binary_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @binary_order
    assert_response :success
  end

  test "should update binary_order" do
    patch :update, id: @binary_order, binary_order: { affpay: @binary_order.affpay, depbonus: @binary_order.depbonus, itm: @binary_order.itm, itmpayout: @binary_order.itmpayout, direction: @binary_order.direction, pool: @binary_order.pool, prembalance: @binary_order.prembalance, premium: @binary_order.premium, profit: @binary_order.profit, sysbonus: @binary_order.sysbonus, user_id: @binary_order.user_id }
    assert_redirected_to binary_order_path(assigns(:binary_order))
  end

  test "should destroy binary_order" do
    assert_difference('BinaryOrder.count', -1) do
      delete :destroy, id: @binary_order
    end

    assert_redirected_to binary_orders_path
  end
end
